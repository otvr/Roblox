type drawingImmediate_t = {
    Line: (p1: Vector2, p2: Vector2, color: Color3, opacity: number, thickness: number) -> nil;
    Circle: (center: Vector2, radius: number, color: Color3, opacity: number, num_sides: number, thickness: number) -> nil;
    FilledCircle: (center: Vector2, radius: number, color: Color3, num_sides: number, opacity: number) -> nil;
    Triangle: (p1: Vector2, p2: Vector2, p3: Vector2, color: Color3, opacity: number, thickness: number) -> nil;
    FilledTriangle: (p1: Vector2, p2: Vector2, p3: Vector2, color: Color3, opacity: number) -> nil;
    Rectangle: (top_left: Vector2, size: Vector2, color: Color3, opacity: number, thickness: number, rounding: number) -> nil;
    FilledRectangle: (top_left: Vector2, size: Vector2, color: Color3, opacity: number, rounding: number) -> nil;
    Quad: (p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, color: Color3, opacity: number, thickness: number) -> nil;
    FilledQuad: (p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, color: Color3, opacity: number) -> nil;
    Text: (position: Vector2, font: number, font_size: number, color: Color3, opacity: number, text: string, center: boolean) -> nil;
    OutlinedText: (position: Vector2, font: number, font_size: number, color: Color3, opacity: number, outline_color: Color3, outline_opacity: number, text: string, center: boolean) -> nil;
    GetPaint: ( ZIndex: number?) -> RBXScriptSignal;
};

local drawingTypes = {'Text', 'Quad', 'Square', 'Triangle', 'Circle', 'Line'};
local drawingImmediate: drawingImmediate_t = {};
local getgenv = getgenv or function() return {} end;
local cloneref = cloneref or function(...) return ... end;
local newcclosure = newcclosure or function(a) return a end;
local runService: RunService = cloneref(game:GetService('RunService'));
local instNew = Instance.new;
local drawingNew = Drawing.new;
local insert = table.insert;
local clear = table.clear;
local stepped = runService.Stepped;
local cache = {}; do
    cache.__index = cache;
    cache.new = function()
        return setmetatable({ _data = {}; _size = 0 }, cache);
    end;
    cache.add = function(self, value)
        self._size += 1;
        self._data[self._size] = value;
    end;
    cache.get = function(self)
        if (self._size == 0) then return nil end;
        local val = self._data[self._size];
        self._data[self._size] = nil;
        self._size -= 1;
        return val;
    end;
end;
local drawingCache = {
    Line = cache.new();
    Circle = cache.new();
    Triangle = cache.new();
    Square = cache.new();
    Quad = cache.new();
    Text = cache.new();
};
local render  = { Line = {}; Circle = {}; Triangle = {}; Square = {}; Quad = {}; Text = {}; };
local buffer = { Line = {}; Circle = {}; Triangle = {}; Square = {}; Quad = {}; Text = {}; };
local paints  = {};
local ZIndex  = 1;
drawingImmediate.Line = newcclosure(function(p1: Vector2, p2: Vector2, color: Color3, opacity: number, thickness: number): nil
    local line = drawingCache.Line:get() or drawingNew('Line');
    ZIndex += 1
    line.From         = p1;
    line.To           = p2;
    line.Color        = color;
    line.Transparency = opacity;
    line.Thickness    = thickness;
    line.ZIndex       = ZIndex;
    line.Visible      = true;
    insert(render.Line, line);
    return;
end, 'Line');
drawingImmediate.Circle = newcclosure(function(center: Vector2, radius: number, color: Color3, opacity: number, num_sides: number, thickness: number)
    local circle = drawingCache.Circle:get() or Drawing.new("Circle");
    ZIndex += 1
    circle.Position     = center;
    circle.Radius       = radius;
    circle.Color        = color;
    circle.Transparency = opacity;
    if (circle.NumSides) then circle.NumSides = num_sides end;
    circle.Thickness    = thickness;
    circle.Filled       = false;
    circle.ZIndex       = ZIndex;
    circle.Visible      = true;
    insert(render.Circle, circle);
    return;
end, 'Circle');
drawingImmediate.FilledCircle = newcclosure(function(center: Vector2, radius: number, color: Color3, opacity: number, num_sides: number)
    local circle = drawingCache.Circle:get() or Drawing.new("Circle");
    ZIndex += 1
    circle.Position     = center;
    circle.Radius       = radius;
    circle.Color        = color;
    circle.Transparency = opacity;
    if (circle.NumSides) then circle.NumSides = num_sides end;
    circle.Thickness    = 1;
    circle.Filled       = true;
    circle.ZIndex       = ZIndex;
    circle.Visible      = true;
    table.insert(render.Circle, circle);
    return;
end, 'FilledCircle');
drawingImmediate.Triangle = newcclosure(function(p1: Vector2, p2: Vector2, p3: Vector2, color: Color3, opacity: number, thickness: number)
    local tri = drawingCache.Triangle:get() or Drawing.new("Triangle");
    ZIndex += 1
    tri.PointA       = p1;
    tri.PointB       = p2;
    tri.PointC       = p3;
    tri.Color        = color;
    tri.Transparency = opacity;
    tri.Thickness    = thickness;
    tri.Filled       = false;
    tri.ZIndex       = ZIndex;
    tri.Visible      = true;
    table.insert(render.Triangle, tri);
    return;
end, 'Triangle');
drawingImmediate.FilledTriangle = newcclosure(function(p1: Vector2, p2: Vector2, p3: Vector2, color: Color3, opacity: number)
    local tri = drawingCache.Triangle:get() or Drawing.new("Triangle");
    ZIndex += 1
    tri.PointA       = p1;
    tri.PointB       = p2;
    tri.PointC       = p3;
    tri.Color        = color;
    tri.Transparency = opacity;
    tri.Thickness    = 1;
    tri.Filled       = true;
    tri.ZIndex       = ZIndex;
    tri.Visible      = true;
    table.insert(render.Triangle, tri);
end, 'FilledTriangle');
drawingImmediate.Rectangle = newcclosure(function(top_left: Vector2, size: Vector2, color: Color3, opacity: number, thickness: number, rounding: number)
    local rect = drawingCache.Square:get() or Drawing.new("Square");
    ZIndex += 1
    rect.Position     = top_left;
    rect.Size         = size;
    rect.Color        = color;
    rect.Transparency = opacity;
    rect.Thickness    = thickness;
    rect.Filled       = false;
    if (rect.Rounding ~= nil) then rect.Rounding = rounding or 0 end;
    rect.ZIndex       = ZIndex;
    rect.Visible      = true;
    table.insert(render.Square, rect);
end, 'Rectangle');
drawingImmediate.FilledRectangle = newcclosure(function(top_left: Vector2, size: Vector2, color: Color3, opacity: number, rounding: number)
    local rect = drawingCache.Square:get() or Drawing.new("Square");
    ZIndex += 1
    rect.Position     = top_left;
    rect.Size         = size;
    rect.Color        = color;
    rect.Transparency = opacity;
    rect.Thickness    = 1;
    rect.Filled       = true;
    if (rect.Rounding ~= nil) then rect.Rounding = rounding or 0 end;
    rect.ZIndex       = ZIndex;
    rect.Visible      = true;
    table.insert(render.Square, rect);
end, 'FilledRectangle');
drawingImmediate.Quad = newcclosure(function(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, color: Color3, opacity: number, thickness: number)
    local quad = drawingCache.Quad:get() or Drawing.new("Quad");
    ZIndex += 1
    quad.PointA       = p1;
    quad.PointB       = p2;
    quad.PointC       = p3;
    quad.PointD       = p4;
    quad.Color        = color;
    quad.Transparency = opacity;
    quad.Thickness    = thickness;
    quad.Filled       = false;
    quad.ZIndex       = ZIndex;
    quad.Visible      = true;
    table.insert(render.Quad, quad);
end, 'Quad');
drawingImmediate.FilledQuad = newcclosure(function(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2, color: Color3, opacity: number)
    local quad = drawingCache.Quad:get() or Drawing.new("Quad");
    ZIndex += 1
    quad.PointA       = p1;
    quad.PointB       = p2;
    quad.PointC       = p3;
    quad.PointD       = p4;
    quad.Color        = color;
    quad.Transparency = opacity;
    quad.Thickness    = 1;
    quad.Filled       = true;
    quad.ZIndex       = ZIndex;
    quad.Visible      = true;
    table.insert(render.Quad, quad);
end, 'FilledQuad');
drawingImmediate.Text = newcclosure(function(position: Vector2, font: number, font_size: number, color: Color3, opacity: number, text: string, center: boolean)
    local t = drawingCache.Text:get() or Drawing.new("Text");
    ZIndex += 1
    t.Position     = position;
    t.Font         = font;
    t.Size         = font_size;
    t.Color        = color;
    t.Transparency = opacity;
    t.Text         = text;
    t.Center       = center;
    t.Outline      = false;
    t.ZIndex       = ZIndex;
    t.Visible      = true;
    table.insert(render.Text, t);
end, 'Text');
drawingImmediate.OutlinedText = newcclosure(function(position: Vector2, font: number, font_size: number, color: Color3, opacity: number, outline_color: Color3, outline_opacity: number, text: string, center: boolean)
    local t = drawingCache.Text:get() or Drawing.new("Text");
    ZIndex += 1
    t.Position     = position;
    t.Font         = font;
    t.Size         = font_size;
    t.Color        = color;
    t.Transparency = opacity;
    t.OutlineColor = outline_color;
    t.Text         = text;
    t.Center       = center;
    t.Outline      = true;
    t.ZIndex       = ZIndex;
    t.Visible      = true;
    table.insert(render.Text, t);
end, 'OutlinedText');
drawingImmediate.GetPaint = newcclosure(function(_ZIndex: number?): RBXScriptSignal
    _ZIndex = _ZIndex or 1;
    if (not paints[_ZIndex]) then
        paints[_ZIndex] = instNew('BindableEvent');
    end;
    return paints[_ZIndex].Event;
end, 'GetPaint');
task.spawn(runService.PreRender.Connect, runService.PreRender, function()
    for i = 1, #drawingTypes do
        local t = drawingTypes[i];
        local buf = buffer[t];
        for i = 1, #buf do
            buf[i].Visible = false;
            drawingCache[t]:add(buf[i]);
        end;
        clear(buf);
    end;
    stepped:Wait();
    ZIndex = 0;
    for i = 1, #paints do
        paints[i]:Fire();
    end;
    for i = 1, #drawingTypes do
        local t = drawingTypes[i];
        local a = render[t];
        for i = 1, #a do
            buffer[t][i] = a[i];
        end;
        clear(a);
    end;
end);
table.freeze(drawingImmediate);
getgenv().DrawingImmediate = drawingImmediate;
return drawingImmediate;
