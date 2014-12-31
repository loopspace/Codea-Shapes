-- MeshShapes

-- Use this function to perform your initial setup
function setup()
    -- extendMesh()
    parameter.number("rot_x",0,360,0)
    parameter.number("rot_y",0,360,0)
    parameter.number("rot_z",0,360,0)
    parameter.number("size",-1,2,0)
    m = mesh()
    m.shader = lighting()
    m.shader.ambient = .5
    m.shader.light = vec3(0,5,-1):normalize()
    m.shader.useTexture = 1
    local w,h = spriteSize("Cargo Bot:Crate Blue 1")
    img = image(10*w,h)
    setContext(img)
    spriteMode(CORNER)
    sprite("Cargo Bot:Crate Red 1",0,0)
    sprite("Cargo Bot:Crate Green 1",w,0)
    sprite("Cargo Bot:Crate Blue 1",2*w,0)
    sprite("Cargo Bot:Crate Yellow 1",3*w,0)
    sprite("Cargo Bot:Crate Red 2",4*w,0)
    sprite("Cargo Bot:Crate Green 2",5*w,0)
    sprite("Cargo Bot:Crate Blue 2",6*w,0)
    sprite("Cargo Bot:Crate Yellow 2",7*w,0)
    sprite("Cargo Bot:Crate Red 3",8*w,0)
    sprite("Cargo Bot:Crate Green 3",9*w,0)
    setContext()
    m.texture = img
    print("Initial mesh size:", m.size)
    print("Returned values of addJewel:", m:addJewel({
        texOrigin = vec2(0,0),
        texSize = vec2(.2,1)
    }))
    print("Returned values of addPyramid:", m:addPyramid({
        texOrigin = vec2(0,0),
        texSize = vec2(.2,1),
        origin = vec3(0,2,0),
        height = 2,
        sides = 30,
        faceted = false
    }))
    print("Returned values of addPyramid:", m:addPyramid({
        texOrigin = vec2(0,0),
        texSize = vec2(.2,1),
        origin = vec3(2,2,0),
        sides = 30,
        height = 2,
        faceted = true
    }))
    print("Returned values of addCube:", m:addCube({
        centre = vec3(2,0,0),
        size = 2,
        texOrigin = vec2(.2,0),
        colour = color(255, 255, 255, 255),
        texSize = vec2(.6,1)
    }))
    print("Returned values of addCube:", m:addCube({
        centre = vec3(6,0,0),
        size = 2,
        texOrigin = vec2(.2,0),
        texSize = vec2(.1,1),
        colour = color(255, 255, 255, 255),
        singleImage = true
    }))
    print("Returned values of addSphereSegment:", m:addSphereSegment({
        origin = vec3(-4,0,0),
        texOrigin = vec2(0,0),
        texSize = vec2(.5,1),
        colour = color(255, 255, 255, 255),
        startLatitude = 45,
        deltaLatitude = 90,
        startLongitude = 45,
        deltaLongitude = 90,
        number = 6,
        faceted = true
    }))
    print("Returned values of addSphere:", m:addSphere({
        origin = vec3(-2,0,0),
        texOrigin = vec2(0.8,0),
        texSize = vec2(.1,1),
        colour = color(255, 255, 255, 255),
        number = 6,
    -- faceted = true
    }))
    print("Returned values of addSphereSegment:", m:addSphereSegment({
        origin = vec3(4,0,0),
        texOrigin = vec2(0.7,0),
        texSize = vec2(.3,1),
        colour = color(255, 255, 255, 255),
        incoming = vec3(1,1,0),
        outgoing = vec3(0,0,1),
        faceted = true,
        number = 6
    }))
    print("Returned values of addCylinder:", m:addCylinder({
        startCentre = vec3(4,2,0),
        texOrigin = vec2(0,0),
        texSize = vec2(.3,1),
        colour = color(255, 255, 255, 255),
        startRadius = .5,
        endRadius = 1,
        axis = vec3(0,1,0),
        faceted = false,
        number = 15,
        height = 2,
        ends = 3
    }))
    print("Returned values of addCylinder:", m:addCylinder({
        startCentre = vec3(6,2,0),
        endCentre = vec3(4,4,0),
        texOrigin = vec2(0,0),
        texSize = vec2(.1,1),
        colour = color(255, 255, 255, 255),
        startRadius = .5,
        endRadius = 1,
        axes = {vec3(1,0,0),vec3(0,1,0),vec3(0,0,1)},
        origin = vec3(4,3,0),
        faceted = false,
        number = 15,
        height = 0,
        startAngle = 90,
        deltaAngle = 180
    }))
    print("Returned values of addCylinder:", m:addCylinder({
        startCentre = vec3(-4,2,0),
        texOrigin = vec2(0,0),
        texSize = vec2(.5,1),
        colour = color(255, 255, 255, 255),
        startRadius = .5,
        endRadius = 1,
        axis = vec3(0,1,0),
        faceted = false,
        number = 15,
        height = 2,
        startAngle = 90,
        deltaAngle = 180,
        solid = true
    }))
    print("Final mesh size:",m.size)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)
    sprite(img)
    -- This sets the line thickness
    strokeWidth(5)
    camera(0,0,20,0,0,0,0,1,0)
    perspective(45)
    rotate(rot_z,0,0,1)
    rotate(rot_y,0,1,0)
    rotate(rot_x,1,0,0)
    scale(10^size)
    -- Do your drawing here
    m.shader.invModel = modelMatrix():inverse():transpose()
    m:draw()
end

local __doJewel, __doSuspension, __doPyramid, __doCube, __addTriangle, __doSphere, __threeFromTwo, __orthogonalTo, __doCylinder, __discreteNormal, __doCone, __doPoly, __doFacetedClosedCone, __doFacetedOpenCone, __doSmoothClosedCone, __doSmoothOpenCone, __doFacetedClosedCylinder, __doFacetedOpenCylinder, __doSmoothClosedCylinder, __doSmoothOpenCylinder

--[[
| Option       | Default                  | Description |
|:-------------|:-------------------------|:------------|
| `mesh`         | new mesh                 | The mesh to add the shape to. |
| `position`     | end of mesh              | The position in the mesh at which to start the shape. |
| `origin`       | `vec3(0,0,0)`            | The origin (or centre) of the shape. |
| `axis`         | `vec3(0,1,0)`            | The axis specifies the direction of the jewel. |
| `aspect`       | 1                        | The ratio of the height to the diameter of the gem. |
| `size`         | the length of the axis   | The size of the jewel; specifically the distance from the centre to the apex of the jewel. |
| `colour`/`color` | white                  | The colour of the jewel. |
| `texOrigin`    | `vwc2(0,0)`              | If using a sprite sheet, this is the lower left corner of the rectangle associated with this gem. |
| `texSize`      | `vec2(1,1)`              | This is the width and height of the rectangle of the texture associated to this gem.
--]]
function addJewel(t)
    local m = t.mesh or mesh()
    local p = t.position or (m.size + 1)
    p = p + (1-p)%3
    local o = t.origin or vec3(0,0,0)
    local c = t.colour or t.color or color(255, 255, 255, 255)
    local as = t.aspect or 1
    local to = t.texOrigin or vec2(0,0)
    local ts = t.texSize or vec2(1,1)
    local a = {}
    a[1] = t.axis or vec3(0,1,0)
    if t.size then
        a[1] = a[1]:normalize()*t.size
    end
    a[2] = __orthogonalTo(a[1])
    a[3] = a[1]:cross(a[2])
    local la = a[1]:len()
    for i = 2,3 do
        a[i] = as*la*a[i]:normalize()
    end
    local n = t.sides or 12
    if p > m.size - 12*n then
        m:resize(p + 12*n-1)
    end
    return m,p,__doJewel(m,p,n,o,a,c,to,ts)
end

--[[
A jewel is a special case of a "suspension".

m mesh to add shape to
p position of first vertex of shape
n number of sides
o centre of shape (vec3)
a axes (table of vec3s)
col colour
to offset of texture region (vec2)
ts size of texture region (vec2)
--]]
function __doJewel(m,p,n,o,a,col,to,ts)
    local th = math.pi/n
    local cs = math.cos(th)
    local sn = math.sin(th)
    local h = (1 - cs)/(1 + cs)
    local k,b,c,d,tb,tc,td,tex,pol
    tex,pol={},{}
    c = cs*a[2] + sn*a[3]
    d = -sn*a[2] + cs*a[3]
    tc = cs*vec2(ts.x*.25,0) + sn*vec2(0,ts.y*.5)
    td = -sn*vec2(ts.x*.25,0) + cs*vec2(0,ts.y*.5)
    for i = 1,2*n do
        k = 2*(i%2) - 1
        table.insert(pol,o+h*k*a[1]+c)
        table.insert(tex,tc)
        c,d = cs*c + sn*d,-sn*c + cs*d
        tc,td = cs*tc + sn*td,-sn*tc + cs*td
    end
    return __doSuspension(m,p,2*n,o,{o+a[1],o-a[1]},pol,tex,col,to,ts,true,true)
end

--[[
A "suspension" is a double cone on a curve.

m mesh to add shape to
p position of first vertex of shape
n number of points
o centre of shape (vec3)
a apexes (table of 2 vec3s)
v vertices (table of vec3s in cyclic order)
t texture coordinates corresponding to vertices (relative to centre)
col colour
to offset of texture region (vec2)
ts size of texture region (vec2)
f faceted
cl closed curve or not
--]]
function __doSuspension(m,p,n,o,a,v,t,col,to,ts,f,cl)
    local tu
    for i=1,2 do
        tu = to+vec2(ts.x*(i*.5-.25),ts.y*.5)
        p = __doCone(m,p,n,o,a[i],v,t,col,tu,ts,f,cl)
    end
    return p
end

--[[
A "cone" is formed by taking a curve in space and joining each of its points to an apex.
If the original curve is made from line segments, the resulting cone has a natural triangulation which can be used to construct it as a mesh.

m mesh
p position in mesh
n number of points
o "internal" point (to ensure that normals point outwards)
a apex of cone
v table of base points
t table of texture points
col colour
to texture offset
ts not used
f faceted or not
cl closed curve or not
--]]
function __doCone(m,p,n,o,a,v,t,col,to,ts,f,cl)
    if f then
        if cl then
            return __doFacetedClosedCone(m,p,n,o,a,v,t,col,to,ts)
        else
            return __doFacetedOpenCone(m,p,n,o,a,v,t,col,to,ts)
        end
    else
        if cl then
            return __doSmoothClosedCone(m,p,n,o,a,v,t,col,to,ts)
        else
            return __doSmoothOpenCone(m,p,n,o,a,v,t,col,to,ts)
        end
    end
end

function __doFacetedClosedCone(m,p,n,o,a,v,t,col,to,ts)
    local j,nml
    for k=1,n do
        j = k%n + 1
        nml = (v[k] - a):cross(v[j] - a)
        if nml:dot(a - o) < 0 then
            nml = -nml
        end
        nml = nml:normalize()
        __addTriangle(m,p,v[j],v[k],a,col,col,col,nml,nml,nml,to+t[j],to+t[k],to)
        p = p + 3
    end
    return p
end

function __doFacetedOpenCone(m,p,n,o,a,v,t,col,to,ts)
    local j,nml
    for k=1,n-1 do
        j = k + 1
        nml = (v[k] - a):cross(v[j] - a)
        if nml:dot(a - o) < 0 then
            nml = -nml
        end
        nml = nml:normalize()
        __addTriangle(m,p,v[j],v[k],a,col,col,col,nml,nml,nml,to+t[j],to+t[k],to)
        p = p + 3
    end
    return p
end

function __doSmoothClosedCone(m,p,n,o,a,v,t,col,to,ts)
    local j,nmla,nmlb,nmlc
    nmlb = vec3(0,0,0)
    nmlc = __discreteNormal(v[1],o,v[n],a,v[2])
    for k=1,n do
        j = k%n + 1
        nmla = nmlc
        nmlc = __discreteNormal(v[j],o,v[k],a,v[j%n+1])
        __addTriangle(m,p,v[j],v[k],a,col,col,col,nmlc,nmla,nmlb,to+t[j],to+t[k],to)
        p = p + 3
    end
    return p
end

function __doSmoothOpenCone(m,p,n,o,a,v,t,col,to,ts)
    local j,nmla,nmlb,nmlc
    nmlb = vec3(0,0,0)
    nmlc = __discreteNormal(v[1],o,a,v[2])
    for k=1,n-2 do
        j = k + 1
        nmla = nmlc
        nmlc = __discreteNormal(v[j],o,v[k],a,v[j%n+1])
        __addTriangle(m,p,v[j],v[k],a,col,col,col,nmlc,nmla,nmlb,to+t[j],to+t[k],to)
        p = p + 3
    end
    nmla = nmlc
    nmlc = __discreteNormal(v[n],o,v[n-1],a)
    __addTriangle(m,p,v[n],v[n-1],a,col,col,col,nmlc,nmla,nmlb,to+t[n],to+t[n-1],to)
    return p + 3
end

--[[
This forms a surface which has boundary a given curve by forming a cone with the barycentre of the curve as its apex.

m mesh
p position in mesh
n number of points
o "internal" point (for normals)
v table of base points
t table of texture points
col colour
to texture offset
ts not used
f faceted or not
cl closed curve or not
--]]
function __doPoly(m,p,n,o,v,t,col,to,ts,f,cl)
    local a,b,r = vec3(0,0,0),vec2(0,0),0
    for k,u in ipairs(v) do
        a = a + u
        r = r + 1
    end
    a = a / r
    for k,u in ipairs(t) do
        b = b + u
    end
    b = b / r
    for k=1,r do
        t[k] = t[k] - b
    end
    return __doCone(m,p,n,o,a,v,t,col,to+b,ts,f,cl)
end

--[[
| Option | Default | Description |
|:-------|:--------|:------------|
| `mesh` | new mesh | The mesh to add the shape to. |
| `position` | end of mesh | The place in the mesh at which to add the shape. |
| `colour`/`color` | white | The colour of the shape. |
| `faceted` | true | Whether to make it faceted or smooth. |
| `ends` | `0` | Which ends to fill in (`0` for none, `1` for start, `2` for end, `3` for both) |
| `texOrigin`    | `vwc2(0,0)`              | If using a sprite sheet, this is the lower left corner of the rectangle associated with this shape. |
| `texSize`      | `vec2(1,1)`              | This is the width and height of the rectangle of the texture associated to this shape. |

There are various ways to specify the dimensions of the cylinder.
If given together, the more specific overrides the more general.

`radius` and `height` (`number`s) can be combined with `axes` (table of three `vec3`s) to specify the dimensions, where the first axis vector lies along the cylinder.  The vector `origin` then locates the cylinder in space.

`startCentre`/`startCenter` (a `vec3`), `startWidth` (`number` or `vec3`), `startHeight` (`number` or `vec3`), `startRadius` (`number`) specify the dimensions at the start of the cylinder (if numbers, they are taken with respect to certain axes).

Similarly named options control the other end.

If axes are needed, these can be supplied via the `axes` option.
If just the `axis` option is given (a single `vec3`), this is the direction along the cylinder.
Other directions (if needed) are found by taking orthogonal vectors to this axis.
--]]
										
function addCylinder(t)
    t = t or {}
    local m = t.mesh or mesh()
    local p = t.position or (m.size + 1)
    p = p + (1-p)%3
    local ip = p
    local col = t.colour or t.color or color(255, 255, 255, 255)
    local f = true
    local ends
    local solid = t.solid
    if solid then
        ends = t.ends or 3
    else
        ends = t.ends or 0
    end
    if t.faceted ~= nil then
        f = t.faceted
    end
    local r = t.radius or 1
    local h = t.height or 1
    local to = t.texOrigin or vec2(0,0)
    local ts = t.texSize or vec2(1,1)
    local sc,si,sj,ec,ei,ej,a,o
    
    if t.axis or t.axes then
        a = t.axis or t.axes[1]
        if t.height then
            a = h*a:normalize()
        end
        if t.origin then
            sc,ec = t.origin - a/2,t.origin + a/2
        end
    end
    sc = t.startCentre or t.startCenter or sc
    ec = t.endCentre or t.endCenter or ec
    sc,ec,a = __threeFromTwo(sc,ec,a,vec3(0,0,0),vec3(0,h,0),vec3(0,h,0))
    si = t.startWidth or t.startRadius or t.radius or 1
    sj = t.startHeight or t.startRadius or t.radius or 1
    ei = t.endWidth or t.endRadius or t.radius or 1
    ej = t.endHeight or t.endRadius or t.radius or 1
    local c,d
    if t.axes then
        a,c,d = unpack(t.axes)
    end
    if type(si) == "number" then
        if type(sj) == "number" then
            if not c then
                c = __orthogonalTo(a)
            end
            si = si*c:normalize()
            if not d then
                sj = sj*a:cross(c):normalize()
            else
                sj = sj*d:normalize()
            end
        else
            si = si*sj:cross(a):normalize()
        end
    elseif type(sj) == "number" then
        sj = sj*a:cross(si):normalize()
    end
    if type(ei) == "number" then
        if type(ej) == "number" then
            if not c then
                c = __orthogonalTo(a)
            end
            ei = ei*c:normalize()
            if not d then
                ej = ej*a:cross(c):normalize()
            else
                ej = ej*d:normalize()
            end
        else
            ei = ei*ej:cross(a):normalize()
        end
    elseif type(ej) == "number" then
        ej = ej*a:cross(ei):normalize()
    end

    local n = t.size or 12
    local sa,ea,da = __threeFromTwo(t.startAngle,t.endAngle,t.deltaAngle,0,360,360)
    local closed
    if da == 360 then
        closed = true
        solid = false
    else
        closed = false
    end
    sa = math.rad(sa)
    ea = math.rad(ea)
    da = math.rad(da)/n
    o = t.origin or (sc + math.cos((sa+ea)/2)*si + math.sin((sa+ea)/2)*sj + ec + math.cos((sa+ea)/2)*ei + math.sin((sa+ea)/2)*ej)/2
    local ss = 1 + math.floor((ends+1)/2)
    if solid then
        ss = ss + 2 
    end
    ts.x = ts.x / ss
    local cs,sn,ti,tj
    ti,tj = vec2(ts.x/2,0),vec2(0,ts.y/2)
    cs = math.cos(sa)
    sn = math.sin(sa)
    si,sj = cs*si + sn*sj, -sn*si + cs*sj
    ei,ej = cs*ei + sn*ej, -sn*ei + cs*ej
    ti,tj = cs*ti + sn*tj, -sn*ti + cs*tj
    local u,v,tu,tv,tw,cnrs = {},{},{},{},{},{}
    cnrs[1] = {sc,sc+si,ec+ei,ec}
    cs = math.cos(da)
    sn = math.sin(da)
    for k=0,n do
        table.insert(u,sc+si)
        table.insert(v,ec+ei)
        table.insert(tu,to + vec2(ts.x*k/n,0))
        table.insert(tv,to + vec2(ts.x*k/n,ts.y))
        table.insert(tw,ti)
        si,sj = cs*si + sn*sj, -sn*si + cs*sj
        ei,ej = cs*ei + sn*ej, -sn*ei + cs*ej
        ti,tj = cs*ti + sn*tj, -sn*ti + cs*tj
    end
    cnrs[2] = {sc, sc+cs*si - sn*sj, ec+cs*ei - sn*ej, ec}
    local size = 6*n + math.floor((ends+1)/2)*3*n
    if closed then
        size = size + 6 + math.floor((ends+1)/2)*3
    elseif solid then
        size = size + 24
    end
    if p - 1 + size > m.size then
        m:resize(p-1+size)
    end
    n = n + 1
    p = __doCylinder(m,p,n,o,u,v,tu,tv,col,f,closed)
    to = to + ts/2
    if solid and not closed then
        local tex = {-ts/2,vec2(ts.x/2,-ts.y/2),ts/2,vec2(-ts.x/2,ts.y/2)}
        for i=1,2 do
            to.x = to.x + ts.x
            p = __doPoly(m,p,4,o,cnrs[i],tex,col,to,ts,f,true)
        end
    end

    if ends%2 == 1 then
        to.x = to.x + ts.x
        p = __doCone(m,p,n,o,sc,u,tw,col,to,ts,f,closed)
    end
    if ends >= 2 then
        to.x = to.x + ts.x
        p = __doCone(m,p,n,o,ec,v,tw,col,to,ts,f,closed)
    end
    return m,ip, p
end

--[[
This adds a cylinder to the mesh.

m mesh to add shape to
p position of first vertex of shape
n number of points
o centre of shape (vec3)
a apexes (table of 2 vec3s)
v vertices (table of vec3s in cyclic order)
t texture coordinates corresponding to vertices (relative to centre)
col colour
to offset of texture region (vec2)
ts size of texture region (vec2)
f faceted
cl closed
--]]
function __doCylinder(m,p,n,o,u,v,ut,vt,col,f,cl)
    if f then
        if cl then
            return __doFacetedClosedCylinder(m,p,n,o,u,v,ut,vt,col)
        else
            return __doFacetedOpenCylinder(m,p,n,o,u,v,ut,vt,col)
        end
    else
        if cl then
            return __doSmoothClosedCylinder(m,p,n,o,u,v,ut,vt,col)
        else
            return __doSmoothOpenCylinder(m,p,n,o,u,v,ut,vt,col)
        end
    end
end

function __doFacetedClosedCylinder(m,p,n,o,u,v,ut,vt,col)
    local i,j,nv,nu
    for k=1,n do
        j = k%n + 1
        nu = (u[j] - u[k]):cross(v[k] - u[k]):normalize()
        nv = (v[j] - v[k]):cross(u[k] - v[k]):normalize()
        if nu:dot(u[k]-o) < 0 then
            nu = -nu
        end
        if nv:dot(v[k]-o) < 0 then
            nv = -nv
        end
        __addTriangle(m,p,v[j],v[k],u[j],col,col,col,nv,nv,nv,vt[j],vt[k],ut[j])
        p = p + 3
        __addTriangle(m,p,v[k],u[j],u[k],col,col,col,nu,nu,nu,vt[k],ut[j],ut[k])
        p = p + 3
    end
    return p
end

function __doFacetedOpenCylinder(m,p,n,o,u,v,ut,vt,col)
    local i,j,nv,nu
    for k=1,n-1 do
        j = k + 1
        nu = (u[j] - u[k]):cross(v[k] - u[k]):normalize()
        nv = (v[j] - v[k]):cross(u[k] - v[k]):normalize()
        if nu:dot(u[k]-o) < 0 then
            nu = -nu
        end
        if nv:dot(v[k]-o) < 0 then
            nv = -nv
        end
        __addTriangle(m,p,v[j],v[k],u[j],col,col,col,nv,nv,nv,vt[j],vt[k],ut[j])
        p = p + 3
        __addTriangle(m,p,v[k],u[j],u[k],col,col,col,nu,nu,nu,vt[k],ut[j],ut[k])
        p = p + 3
    end
    return p
end

function __doSmoothClosedCylinder(m,p,n,o,u,v,ut,vt,col)
    local i,j,nv,nu
    nv,nu = {},{}
    nv[1] = __discreteNormal(v[1],o,v[n],u[1],v[2])
    nu[1] = __discreteNormal(u[1],o,u[n],v[1],u[2])
    for k=1,n do
        j = k%n + 1
        i = j%n + 1
        nv[j] = __discreteNormal(v[j],o,v[k],u[j],v[i])
        nu[j] = __discreteNormal(u[j],o,u[k],v[j],u[i])
        __addTriangle(m,p,v[j],v[k],u[j],col,col,col,nv[j],nv[k],nu[j],vt[j],vt[k],ut[j])
        p = p + 3
        __addTriangle(m,p,v[k],u[j],u[k],col,col,col,nv[k],nu[j],nu[k],vt[k],ut[j],ut[k])
        p = p + 3
    end
    return p
end

function __doSmoothOpenCylinder(m,p,n,o,u,v,ut,vt,col)
    local i,j,nv,nu
    nv,nu = {},{}
    nv[1] = __discreteNormal(v[1],o,u[1],v[2])
    nu[1] = __discreteNormal(u[1],o,v[1],u[2])
    for k=1,n-2 do
        j = k + 1
        i = j + 1
        nv[j] = __discreteNormal(v[j],o,v[k],u[j],v[i])
        nu[j] = __discreteNormal(u[j],o,u[k],v[j],u[i])
        __addTriangle(m,p,v[j],v[k],u[j],col,col,col,nv[j],nv[k],nu[j],vt[j],vt[k],ut[j])
        p = p + 3
        __addTriangle(m,p,v[k],u[j],u[k],col,col,col,nv[k],nu[j],nu[k],vt[k],ut[j],ut[k])
        p = p + 3
    end
    nv[n] = __discreteNormal(v[n],o,v[n-1],u[n])
    nu[n] = __discreteNormal(u[n],o,u[n-1],v[n])
    __addTriangle(m,p,v[n],v[n-1],u[n],col,col,col,nv[n],nv[n-1],nu[n],vt[n],vt[n-1],ut[n])
    p = p + 3
    __addTriangle(m,p,v[n-1],u[n],u[n-1],col,col,col,nv[n-1],nu[n],nu[n-1],vt[n-1],ut[n],ut[n-1])
    return p+3
end


--[[
This works out a normal vector for a vertex in a triangulated surface by taking an average of the triangles in which it appears.
The normals are weighted by the reciprocal of the size of the corresponding triangle.

a vertex under consideration
o a point to determine which side the normals lie
... a cyclic list of vertices, successive pairs of which make up the triangles
--]]
function __discreteNormal(a,o,...)
    local n = arg.n
    local na,nb
    na = vec3(0,0,0)
    for k=2,n do
        nb = (arg[k] - a):cross(arg[k-1] - a)
        na = na + nb/nb:lenSqr()
    end
    na = na:normalize()
    if na:dot(a-o) < 0 then
        na = -na
    end
    return na
end

--[[
Adds a pyramid to a mesh.

| Option       | Default                  | Description |
|:-------------|:-------------------------|:------------|
| `mesh`         | new mesh                 | The mesh to add the shape to. |
| `position`     | end of mesh              | The position in the mesh at which to start the shape. |
| `origin`       | `vec3(0,0,0)`            | The origin (or centre) of the shape. |
| `axis`         | `vec3(0,1,0)`            | The axis specifies the direction of the jewel. |
| `aspect`       | 1                        | The ratio of the height to the diameter of the gem. |
| `size`         | the length of the axis   | The size of the jewel; specifically the distance from the centre to the apex of the jewel. |
| `colour`/`color` | `color(255, 255, 255, 255)` | The colour of the jewel. |
| `texOrigin`    | `vwc2(0,0)`              | If using a sprite sheet, this is the lower left corner of the rectangle associated with this gem. |
| `texSize`      | `vec2(1,1)`              | This is the width and height of the rectangle of the texture associated to this gem.
--]]
function addPyramid(t)
    local m = t.mesh or mesh()
    local p = t.position or (m.size + 1)
    p = p + (1-p)%3
    local o = t.origin or vec3(0,0,0)
    local c = t.colour or t.color or color(255, 255, 255, 255)
    local f = true
    if t.faceted ~= nil then
        f = t.faceted
    end
    local as = t.aspect or 1
    local to = t.texOrigin or vec2(0,0)
    local ts = t.texSize or vec2(1,1)
    local a = t.axes or {}
    a[1] = t.apex or a[1] or vec3(0,1,0)
    if t.size then
        a[1] = a[1]:normalize()*t.size
    end
    if not a[2] then
        local ax,ay,az = math.abs(a[1].x),math.abs(a[1].y),math.abs(a[1].z)
        if ax < ay and ax < az then
            a[2] = vec3(0,a[1].z,-a[1].y)
        elseif ay < az then
            a[2] = vec3(a[1].z,0,-a[1].x)
        else
            a[2] = vec3(a[1].y,-a[1].x,0)
        end
        a[3] = a[1]:cross(a[2])
    end
    local la = a[1]:len()
    for i = 2,3 do
        a[i] = as*la*a[i]:normalize()
    end
    local n = t.sides or 12
    if p > m.size - 6*n then
        m:resize(p + 6*n-1)
    end
    return m,p,__doPyramid(m,p,n,o,a,c,to,ts,f,true)
end

--[[
A pyramid is a special case of a suspension.

m mesh
p position
n number of points
o origin
a apex
col colour
to texture offset
ts texture size
f faceted
--]]
function __doPyramid(m,p,n,o,a,col,to,ts,f)
    local th = 2*math.pi/n
    local cs = math.cos(th)
    local sn = math.sin(th)
    local b,c,d,tb,tc,td,tex,pol
    tex,pol={},{}
    c = cs*a[2] + sn*a[3]
    d = -sn*a[2] + cs*a[3]
    tc = cs*vec2(ts.x*.25,0) + sn*vec2(0,ts.y*.5)
    td = -sn*vec2(ts.x*.25,0) + cs*vec2(0,ts.y*.5)
    for i = 1,n do
        table.insert(pol,o+c)
        table.insert(tex,tc)
        c,d = cs*c + sn*d, -sn*c + cs*d
        tc,td = cs*tc + sn*td, -sn*tc + cs*td
    end
    return __doSuspension(m,p,n,o+a[1]/2,{o+a[1],o},pol,tex,col,to,ts,f,true)
end

-- cube faces are in binary order: 000, 001, 010, 011 etc
local CubeFaces = {
        {1,2,3,4},
        {5,7,6,8},
        {1,5,2,6},
        {3,4,7,8},
        {2,6,4,8},
        {1,3,5,7}
    }
local CubeTex = {
    vec2(0,0),vec2(1/6,0),vec2(0,1),vec2(1/6,1)
}
--[[
Adds a cube to a mesh.

| Option | Default | Description |
|:-------|:--------|:------------|
| `mesh`                     | new mesh | Mesh to use to add shape to. |
| `position`                 | end of mesh | Position in mesh to add shape at. |
| `colour`/`color` | color(255, 255, 255, 255) | Colour or colours to use.  Can be a table of colours, one for each vertex of the cube. |
| `faces`        | all         | Which faces to render |
| `texOrigin`    | `vec2(0,0)` | Lower left corner of region on texture. |
| `texSize`      | `vec2(1,1)` | Width and height of region on texture. |
| `singleImage`  | `false`     | Uses the same image for all sides. |

There are a few ways of specifying the dimensions of the "cube".

`centre`/`center`, `width`, `height`, `depth`, `size`.  This defines the "cube" by specifying a centre followed by the width, height, and depth of the cube (`size` sets all three).  These can be `vec3`s or numbers.  If numbers, they correspond to the dimensions of the "cube" in the `x`, `y`, and `z` directions respectively.  If `vec3`s, then are used to construct the vertices by adding them to the centre so that the edges of the "cube" end up parallel to the given vectors.

`startCentre`/`startCenter`, `startWidth`, `startHeight`, `endCentre`/`endCenter`, `endWidth`, `endHeight`.  This defined the "cube" by defining two opposite faces of the cube and then filling in the region in between.  The two faces are defined by their centres, widths, and heights.  The widths and heights can be numbers or `vec3`s exactly as above.

`cube`.  This is a table of eight vertices defining the cube.  The vertices are listed in binary order, in that if you picture the vertices of the standard cube of side length `1` with one vertex at the origin, the vertex with coordinates `(a,b,c)` is number a + 2b + 4c + 1 in the table (the `+1` is because lua tables are 1-based).
--]]
function addCube(t)
    local m = t.mesh or mesh()
    local p = t.position or (m.size + 1)
    p = p + (1-p)%3
    local c = t.colour or t.color or color(255, 255, 255, 255)
    if type(c) == "userdata" then
        c = {c,c,c,c,c,c,c,c}
    end
    local f = t.faces or CubeFaces
    local to = t.texOrigin or vec2(0,0)
    local ts = t.texSize or vec2(1,1)
    local dt = 1
    if t.singleImage then
        dt = 0
        ts.x = ts.x * 6
    end
    local v
    if t.cube then
        v = t.cube
    elseif t.center or t.centre then
        local o = t.center or t.centre
        local w,h,d = t.width or t.size or 1, t.height or t.size or 1, t.depth or t.size or 1
        w,h,d=w/2,h/2,d/2
        if type(w) == "number" then
            w = vec3(w,0,0)
        end
        if type(h) == "number" then
            h = vec3(0,h,0)
        end
        if type(d) == "number" then
            d = vec3(0,0,d)
        end
        v = {
            o - w - h - d,
            o + w - h - d,
            o - w + h - d,
            o + w + h - d,
            o - w - h + d,
            o + w - h + d,
            o - w + h + d,
            o + w + h + d
        }
    elseif t.startCentre or t.startCenter then
        local sc = t.startCentre or t.startCenter
        local ec = t.endCentre or t.endCenter
        local sw = t.startWidth
        local sh = t.startHeight
        local ew = t.endWidth
        local eh = t.endHeight
        if type(sw) == "number" then
            sw = vec3(sw,0,0)
        end
        if type(sh) == "number" then
            sh = vec3(0,sh,0)
        end
        if type(sc) == "number" then
            sc = vec3(0,0,sc)
        end
        if type(ew) == "number" then
            ew = vec3(ew,0,0)
        end
        if type(eh) == "number" then
            eh = vec3(0,eh,0)
        end
        if type(ec) == "number" then
            ec = vec3(0,0,ec)
        end
        v = {
            sc - sw - sh,
            sc + sw - sh,
            sc - sw + sh,
            sc + sw + sh,
            ec - ew - eh,
            ec + ew - eh,
            ec - ew + eh,
            ec + ew + eh
        }
    else
        v = {
            vec3(0,0,0),
            vec3(1,0,0),
            vec3(0,1,0),
            vec3(1,1,0),
            vec3(0,0,1),
            vec3(1,0,1),
            vec3(0,1,1),
            vec3(1,1,1),
        }
    end
    if p > m.size - 36 then
        m:resize(p + 35)
    end
    return m,p,__doCube(m,p,f,v,c,to,ts,dt)
end

--[[
m mesh
p index of first vertex to be used
f table of faces of cube
v table of vertices of cube
c table of colours of cube (per vertex of cube)
to offset for this shape's segment of the texture
ts size of this shape's segment of the texture
dt step size for the texture tiling
--]]
function __doCube(m,p,f,v,c,to,ts,dt)
    local n,t,tv
    t = 0
    for k,w in ipairs(f) do
        n = (v[w[3]] - v[w[1]]):cross(v[w[2]] - v[w[1]]):normalize()
        for i,u in ipairs({1,2,3,2,3,4}) do
            m:vertex(p,v[w[u]])
            m:color(p,c[w[u]])
            m:normal(p,n)
            tv = CubeTex[u] + t*vec2(1/6,0)
            tv.x = tv.x * ts.x
            tv.y = tv.y * ts.y
            m:texCoord(p, to + tv)
            p = p + 1
        end
        t = t + dt
    end
    return p
end

--[[
Adds a sphere to a mesh.

| Options | Defaults | Description |
|:--------|:---------|:------------|
| `mesh` | New mesh | Mesh to add shape to. |
| `position` | End of mesh | Position at which to add shape. |
| `origin`/`centre`/`center` | `vec3(0,0,0)` | Centre of sphere. |
| `axes` | Standard axes | Axes of sphere. |
| `size` | `1` | Radius of sphere (relative to axes). |
| `colour`/`color` | `color(255, 255, 255, 255)` | Colour of sphere. |
| `faceted` | `false` | Whether to render the sphere faceted or smoothed (not yet implemented). |
| `number` | `36` | Number of steps to use to render sphere (twice this for longitude. |
| `texOrigin` | `vec2(0,0)` | Origin of region in texture to use. |
| `texSize` | `vec2(0,0)` | Width and height of region in texture to use.|
--]]
function addSphere(t)
    local m = t.mesh or mesh()
    local p = t.position or (m.size + 1)
    p = p + (1-p)%3
    local o = t.origin or t.centre or t.center or vec3(0,0,0)
    local s = t.size or 1
    local c = t.colour or t.color or color(255, 255, 255, 255)
    local n = t.number or 36
    local a = t.axes or {vec3(1,0,0),vec3(0,1,0),vec3(0,0,1)}
    a[1],a[2],a[3] = s*a[1],s*a[2],s*a[3]
    local to = t.texOrigin or vec2(0,0)
    local ts = t.texSize or vec2(1,1)
    local f = false
    if t.faceted ~= nil then
        f = t.faceted
    end
    if p > m.size - 12*n*(n-1) then
        m:resize(p+12*n*(n-1)-1)
    end
    local step = math.pi/n
    return m,p,__doSphere(m,p,o,a,0,step,n,0,step,2*n,c,f,to,ts)
end

--[[
Adds a segment of a sphere to a mesh.

| Options | Defaults | Description |
|:--------|:---------|:------------|
| `mesh` | New mesh | Mesh to add shape to. |
| `position` | End of mesh | Position at which to add shape. |
| `origin`/`centre`/`center` | `vec3(0,0,0)` | Centre of sphere. |
| `axes` | Standard axes | Axes of sphere. |
| `size` | `1` | Radius of sphere (relative to axes). |
| `colour`/`color` | `color(255, 255, 255, 255)` | Colour of sphere. |
| `faceted` | `false` | Whether to render the sphere faceted or smoothed (not yet implemented). |
| `number` | `36` | Number of steps to use to render sphere (twice this for longitude. |
| `solid` | `true` | Whether to make the sphere solid by filling in the internal sides. |
| `texOrigin` | `vec2(0,0)` | Origin of region in texture to use. |
| `texSize` | `vec2(0,0)` | Width and height of region in texture to use.|

Specifying the segment can be done in a variety of ways.

`startLatitude`, `endLatitude`, `deltaLatitude`, `startLongitude`, `endLongitude`, `deltaLongitude` specify the latitude and longitude for the segment relative to given axes (only two of the three pieces of information for each need to be given).

`incoming` and `outgoing` define directions that the ends of the segment will point towards.

--]]
function addSphereSegment(t)
    local m = t.mesh or mesh()
    local p = t.position or (m.size + 1)
    p = p + (1-p)%3
    local ip = p
    local o = t.origin or t.centre or t.center or vec3(0,0,0)
    local s = t.size or 1
    local c = t.colour or t.color or color(255, 255, 255, 255)
    local n = t.number or 36
    local solid = true
    if t.solid ~= nil then
        solid = t.solid
    end
    local a,st,dt,et,sp,dp,ep
    if t.incoming then
        a = {}
        a[3] = t.incoming:cross(t.outgoing)
        if a[3]:lenSqr() == 0 then
            if t.axes then
                a[3] = t.axes[3] - t.axes[3]:dot(t.incoming)*t.incoming/t.incoming:lenSqr()
            end
            if a[3]:lenSqr() == 0 then
                a[3] = __orthogonalTo(t.incoming)
            end
        end
        a[3] = a[3]:normalize()
        a[2] = t.incoming:normalize()
        a[1] = a[2]:cross(a[3])
        local w = a[3]:cross(t.outgoing):normalize()
        dp = math.acos(a[1]:dot(w))
        sp = 0
        ep = dp
        st = 0
        dt = math.pi
        et = math.pi
    else
        a = t.axes or {vec3(1,0,0),vec3(0,1,0),vec3(0,0,1)}
        a[1],a[2],a[3] = s*a[1],s*a[2],s*a[3]
        sp,ep,dp = __threeFromTwo(t.startLongitude,t.endLongitude,t.deltaLongitude,0,180,180)
        st,et,dt = __threeFromTwo(t.startLatitude,t.endLatitude,t.deltaLatitude,0,360,360)
        sp = sp/180*math.pi
        dp = dp/180*math.pi
        ep = ep/180*math.pi
        st = st/180*math.pi
        dt = dt/180*math.pi
        et = et/180*math.pi
    end
    local step = math.pi/n
    local nt = math.ceil(dt/step)
    local np = math.ceil(dp/step)
    dt = dt / nt
    dp = dp / np
    local to = t.texOrigin or vec2(0,0)
    local ts = t.texSize or vec2(1,1)
    local f = false
    if t.faceted ~= nil then
        f = t.faceted
    end
    local size = 6*nt*np
    if st == 0 then
        size = size - 3*np
    end
    if et >= math.pi then
        size = size - 3*np
    end
    if solid then
        size = size + 6*(nt+3)
        local ss = 3
        if st ~= 0 then
            size = size + 3*np
            ss = ss + 1
        end
        if et < math.pi then
            size = size + 3*np
            ss = ss + 1
        end
        ts.x = ts.x/ss
    end
    if p > m.size - size then
        m:resize(p-1+size)
    end
    p = __doSphere(m,p,o,a,st,dt,nt,sp,dp,np,c,f,to,ts)
    if solid then
        to.x = to.x + ts.x
        local intl = o + math.sin(st+nt*dt/2)*math.cos(sp+np*dp/2)*a[1] + math.sin(st+nt*dt/2)*math.sin(sp+dp*np/2)*a[2] + math.cos(st+nt*dt/2)*a[3]
        local v,tex = {},{}
        local tl,tu = math.cos(st), math.cos(et) - math.cos(st)
        table.insert(v,o + math.cos(st)*a[3])
        table.insert(tex,vec2(ts.x,0))
        for k=0,nt do
            table.insert(v,o+math.sin(st+k*dt)*math.cos(sp)*a[1] + math.sin(st+k*dt)*math.sin(sp)*a[2] + math.cos(st+k*dt)*a[3])
            table.insert(tex,vec2(ts.x*(1-math.sin(st+k*dt)),ts.y*(math.cos(st+k*dt) - tl)/tu))
        end
        table.insert(v,o + math.cos(et)*a[3])
        table.insert(tex,ts)
        p = __doPoly(m,p,nt+3,intl,v,tex,c,to,ts,f,true)
        to.x = to.x + ts.x
        v,tex = {},{}
        table.insert(v,o + math.cos(st)*a[3])
        table.insert(tex,vec2(0,0))
        for k=0,nt do
            table.insert(v,o+math.sin(st+k*dt)*math.cos(ep)*a[1] + math.sin(st+k*dt)*math.sin(ep)*a[2] + math.cos(st+k*dt)*a[3])
            table.insert(tex,vec2(ts.x*math.sin(st+k*dt),ts.y*(math.cos(st+k*dt) - tl)/tu))
        end
        table.insert(v,o + math.cos(et)*a[3])
        table.insert(tex,vec2(0,ts.y))
        p = __doPoly(m,p,nt+3,intl,v,tex,c,to,ts,f,true)
        to = to + ts/2
        if st ~= 0 then
            to.x = to.x + ts.x
            v,tex = {},{}
            for k=0,np do
                table.insert(v,o+math.sin(st)*math.cos(sp+k*dp)*a[1] + math.sin(st)*math.sin(sp+k*dp)*a[2] + math.cos(st)*a[3])
                table.insert(tex,vec2(ts.x*math.sin(sp+k*dp)/2,ts.y*math.cos(sp+k*dp)/2))
            end
            p = __doCone(m,p,np+1,intl,o + math.cos(st)*a[3],v,tex,c,to,ts,f,false)
        end
        if et < math.pi then
            to.x = to.x + ts.x
            v,tex = {},{}
            for k=0,np do
                table.insert(v,o+math.sin(et)*math.cos(sp+k*dp)*a[1] + math.sin(et)*math.sin(sp+k*dp)*a[2] + math.cos(et)*a[3])
                table.insert(tex,vec2(ts.x*math.sin(sp+k*dp)/2,ts.y*math.cos(sp+k*dp)/2))
            end
            p = __doCone(m,p,np+1,intl,o + math.cos(et)*a[3],v,tex,c,to,ts,f,false)
        end
    end
    return m,ip,p
end

--[[
Adds a sphere or segment of the surface of a sphere.

m mesh
p position of first vertex
o origin
a axes (table of vec3s)
st start angle for theta
dt delta angle for theta
nt number of steps for theta
sp start angle for phi
dp delta angle for phi
np number of steps for phi
c colour
f faceted or smooth
to offset for this shape's segment of the texture
ts size of this shape's segment of the texture
--]]
function __doSphere(m,p,o,a,st,dt,nt,sp,dp,np,c,f,to,ts)
    local theta,ptheta,phi,pphi,ver,et,ep,tx,l,tex,stt,ett
    et = nt*dt/ts.y
    ep = np*dp/ts.x
    if st == 0 then
        stt = 2
    else
        stt = 1
    end
    if st + nt*dt >= math.pi then
        ett = nt-1
    else
        ett = nt
    end
    for i = stt,ett do
        theta = st + i*dt
        ptheta = st + (i-1)*dt
        for j=1,np do
            phi = sp + j*dp
            pphi = sp + (j-1)*dp
            ver = {}
            tex = {}
            for k,v in ipairs({
                {ptheta,pphi},
                {ptheta,phi},
                {theta,phi},
                {theta,phi},
                {ptheta,pphi},
                {theta,pphi}
            }) do
                table.insert(ver,math.sin(v[1])*math.cos(v[2])*a[1] + math.sin(v[1])*math.sin(v[2])*a[2] + math.cos(v[1])*a[3])
                table.insert(tex,to + vec2((v[2]-sp)/ep,(v[1]-st)/et))
            end
            for k = 1,6 do
                m:vertex(p,o + ver[k])
                m:color(p,c)
                if f then
                    l = math.floor((k-1)/3)
                    m:normal(p,(-1)^l*(ver[3*l+3] - ver[3*l+1]):cross(ver[3*l+2] - ver[3*l+1]):normalize())
                else
                    m:normal(p,ver[k]:normalize())
                end
                m:texCoord(p,tex[k])
                p = p + 1
            end
        end
    end
    local ends = {}
    if st == 0 then
        table.insert(ends,0)
    end
    if st + nt*dt >= math.pi then
        table.insert(ends,1)
    end
    et = nt*dt
    ep = np*dp
    for _,i in ipairs(ends) do
        for j=1,np do
            phi = sp + j*dp
            pphi = sp + (j-1)*dp
            ver = {}
            tex = {}
            for k,v in ipairs({
                {dt,pphi},
                {dt,phi},
                {0,phi}
            }) do
                table.insert(ver,math.sin(v[1])*math.cos(v[2])*a[1] + math.sin(v[1])*math.sin(v[2])*a[2] + (-1)^i*math.cos(v[1])*a[3])
                tx = vec2((v[2]-sp)/ep,i + (1-2*i)*(v[1]-st)/et)
                tx.x = tx.x * ts.x
                tx.y = tx.y * ts.y
                table.insert(tex,to + tx)
            end
            for k=1,3 do
                m:vertex(p,o + ver[k])
                m:color(p,c)
                if f then
                    m:normal(p,(-1)^i*(ver[2]-ver[1]):cross(ver[3]-ver[1]):normalize())
                else
                    m:normal(p,ver[k]:normalize())
                end
                m:texCoord(p,tex[k])
                p = p + 1
            end
        end
    end
    return p
end

--[[
These make the above available as methods on a mesh.
--]]
local mt = getmetatable(mesh())

local __addShape = function(m,f,t)
    t = t or {}
    local nt = {}
    for k,v in pairs(t) do
        nt[k] = v
    end
    nt.mesh = m
    return f(nt)
end

mt.addJewel = function(m,t)
    return __addShape(m,addJewel,t)
end

mt.addPyramid = function(m,t)
    return __addShape(m,addPyramid,t)
end

mt.addCube = function(m,t)
    return __addShape(m,addCube,t)
end

mt.addCylinder = function(m,t)
    return __addShape(m,addCylinder,t)
end

mt.addSphere = function(m,t)
    return __addShape(m,addSphere,t)
end

mt.addSphereSegment = function(m,t)
    return __addShape(m,addSphereSegment,t)
end


--[[
Adds a triangle to a mesh, with specific vertices, colours, normals, and texture coordinates.
--]]
function __addTriangle(m,p,a,b,c,d,e,f,g,h,i,j,k,l)
    m:vertex(p,a)
    m:color(p,d)
    m:normal(p,g)
    m:texCoord(p,j)
    p = p + 1
    m:vertex(p,b)
    m:color(p,e)
    m:normal(p,h)
    m:texCoord(p,k)
    p = p + 1
    m:vertex(p,c)
    m:color(p,f)
    m:normal(p,i)
    m:texCoord(p,l)
end

--[[
Returns three things, u,v,w, with the property that u + w = v.  The input can be any number of the three together with three defaults to be used if not enough information is given (so if any two of the first three are given then that is enough information to determine the third).
--]]
function __threeFromTwo(a,b,c,d,e,f)
    local u,v,w = a or d or 0, b or e or 1, c or f or 1
    if not a then
        u = v - w
    end
    if not b then
        v = u + w
    end
    if not c then
        w = v - u
    end
    v = u + w
    return u,v,w
end

--[[
Returns a vector orthogonal to the given `vec3`.
--]]
function __orthogonalTo(v)
    local a,b,c = math.abs(v.x), math.abs(v.y), math.abs(v.z)
    if a < b and a < c then
        return vec3(0,v.z,-v.y)
    end
    if b < c then
        return vec3(-v.z,0,v.x)
    end
    return vec3(v.y,-v.x,0)
end

--[[
A basic lighting shader with a texture.
--]]
function lighting()
    return shader([[
    //
// A basic vertex shader
//

//This is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;
uniform mat4 invModel;
//This is the current mesh vertex position, color and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;
attribute vec3 normal;

//This is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying highp vec3 vNormal;

void main()
{
    //Pass the mesh color to the fragment shader
    vColor = color;
    vTexCoord = texCoord;
    highp vec4 n = invModel * vec4(normal,0.);
    vNormal = n.xyz;
    //Multiply the vertex position by our combined transform
    gl_Position = modelViewProjection * position;
}

]],[[
    //
// A basic fragment shader
//

//Default precision qualifier
precision highp float;

//This represents the current texture on the mesh
uniform lowp sampler2D texture;
uniform highp vec3 light;
uniform lowp float ambient;
uniform lowp float useTexture;
//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;
varying highp vec3 vNormal;

void main()
{
    //Sample the texture at the interpolated coordinate
    lowp vec4 col = vColor;//vec4(1.,0.,0.,1.);
    if (useTexture == 1.) {
        col *= texture2D( texture, vTexCoord );
    }

    lowp float c = ambient + (1.-ambient) * max(0.,dot(light, normalize(vNormal)));
    col.xyz *= c;
    //Set the output color to the texture color
    gl_FragColor = col;
}

    ]]
    )
end
