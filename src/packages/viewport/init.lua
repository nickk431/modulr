--[[
MIT License

Copyright (c) 2021 EgoMoose

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local BLOCK = { 0, 1, 2, 3, 4, 5, 6, 7 }
local WEDGE = { 0, 1, 3, 4, 5, 7 }
local CORNER_WEDGE = { 0, 1, 4, 5, 6 }

-- Class

local ViewportModelClass = {}
ViewportModelClass.__index = ViewportModelClass
ViewportModelClass.ClassName = "ViewportModel"

-- Private

local function getIndices(part)
	if part:IsA("WedgePart") then
		return WEDGE
	elseif part:IsA("CornerWedgePart") then
		return CORNER_WEDGE
	end
	return BLOCK
end

local function getCorners(cf, size2, indices)
	local corners = {}
	for j, i in pairs(indices) do
		corners[j] = cf
			* (size2 * Vector3.new(2 * (math.floor(i / 4) % 2) - 1, 2 * (math.floor(i / 2) % 2) - 1, 2 * (i % 2) - 1))
	end
	return corners
end

local function getModelPointCloud(model)
	local points = {}
	for _, part in pairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local indices = getIndices(part)
			local corners = getCorners(part.CFrame, part.Size / 2, indices)
			for _, wp in pairs(corners) do
				table.insert(points, wp)
			end
		end
	end
	return points
end

local function viewProjectionEdgeHits(cloud, axis, depth, tanFov2)
	local max, min = -math.huge, math.huge

	for _, lp in pairs(cloud) do
		local distance = depth - lp.Z
		local halfSpan = tanFov2 * distance

		local a = lp[axis] + halfSpan
		local b = lp[axis] - halfSpan

		max = math.max(max, a, b)
		min = math.min(min, a, b)
	end

	return max, min
end

-- Public Constructors

function ViewportModelClass.new(vpf, camera)
	local self = setmetatable({}, ViewportModelClass)

	self.Model = nil
	self.ViewportFrame = vpf
	self.Camera = camera

	self._points = {}
	self._modelCFrame = CFrame.new()
	self._modelSize = Vector3.new()
	self._modelRadius = 0

	self._viewport = {}

	self:Calibrate()

	return self
end

-- Public Methods

-- Used to set the model that is being focused on
-- should be used for new models and/or a change in the current model
-- e.g. parts added/removed from the model or the model cframe changed
function ViewportModelClass:SetModel(model)
	self.Model = model

	local cf, size = model:GetBoundingBox()

	self._points = getModelPointCloud(model)
	self._modelCFrame = cf
	self._modelSize = size
	self._modelRadius = size.Magnitude / 2
end

-- Should be called when something about the viewport frame / camera changes
-- e.g. the frame size or the camera field of view
function ViewportModelClass:Calibrate()
	local viewport = {}
	local size = self.ViewportFrame.AbsoluteSize

	viewport.aspect = size.X / size.Y

	viewport.yFov2 = math.rad(self.Camera.FieldOfView / 2)
	viewport.tanyFov2 = math.tan(viewport.yFov2)

	viewport.xFov2 = math.atan(viewport.tanyFov2 * viewport.aspect)
	viewport.tanxFov2 = math.tan(viewport.xFov2)

	viewport.cFov2 = math.atan(viewport.tanyFov2 * math.min(1, viewport.aspect))
	viewport.sincFov2 = math.sin(viewport.cFov2)

	self._viewport = viewport
end

-- returns a fixed distance that is guarnteed to encapsulate the full model
-- this is useful for when you want to rotate freely around an object w/o expensive calculations
-- focus position can be used to set the origin of where the camera's looking
-- otherwise the model's center is assumed
function ViewportModelClass:GetFitDistance(focusPosition)
	local displacement = focusPosition and (focusPosition - self._modelCFrame.Position).Magnitude or 0
	local radius = self._modelRadius + displacement

	return radius / self._viewport.sincFov2
end

-- returns the optimal camera cframe that would be needed to best fit
-- the model in the viewport frame at the given orientation.
-- keep in mind this functions best when the model's point-cloud is correct
-- as such models that rely heavily on meshesh, csg, etc will only return an accurate
-- result as their point cloud
function ViewportModelClass:GetMinimumFitCFrame(orientation)
	if not self.Model then
		return CFrame.new()
	end

	local rotation = orientation - orientation.Position
	local rInverse = rotation:Inverse()

	local wcloud = self._points
	local cloud = { rInverse * wcloud[1] }
	local furthest = cloud[1].Z

	for i = 2, #wcloud do
		local lp = rInverse * wcloud[i]
		furthest = math.min(furthest, lp.Z)
		cloud[i] = lp
	end

	local hMax, hMin = viewProjectionEdgeHits(cloud, "X", furthest, self._viewport.tanxFov2)
	local vMax, vMin = viewProjectionEdgeHits(cloud, "Y", furthest, self._viewport.tanyFov2)

	local distance =
		math.max(((hMax - hMin) / 2) / self._viewport.tanxFov2, ((vMax - vMin) / 2) / self._viewport.tanyFov2)

	return orientation * CFrame.new((hMax + hMin) / 2, (vMax + vMin) / 2, furthest + distance)
end

--

return ViewportModelClass
