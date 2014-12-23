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
    m.shader.useTexture = 0
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
    print("Returned values of addCube:", m:addCube({
        centre = vec3(2,0,0),
        size = 2,
        texOrigin = vec2(.2,0),
        texSize = vec2(.6,1)
    }))
    print("Returned values of addSphereSegment:", m:addSphereSegment({
        origin = vec3(-4,0,0),
        texOrigin = vec2(0.8,0),
        texSize = vec2(.1,1),
        colour = color(255, 255, 255, 255),
        startLatitude = 90,
        deltaLatitude = 90
    }))
    print("Returned values of addSphere:", m:addSphere({
        origin = vec3(-2,0,0),
        texOrigin = vec2(0.8,0),
        texSize = vec2(.1,1),
        colour = color(255, 255, 255, 255)
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

local __doJewel, __doCube, __addTriangle, __doSphere, __threeFromTwo

--[[
| option       | default                  | description |
|:-------------|:-------------------------|:------------|
| mesh         | new mesh                 | The mesh to add the shape to. |
| position     | end of mesh              | The position in the mesh at which to start the shape. |
| origin       | `vec3(0,0,0)`            | The origin (or centre) of the shape. |
| axis         | `vec3(0,1,0)`            | The axis specifies the direction of the jewel. |
| aspect       | 1                        | The ratio of the height to the diameter of the gem. |
| size         | the length of the axis   | The size of the jewel; specifically the distance from the centre to the apex of the jewel. |
| colour/color | `color(223,225,124,255)` | The colour of the jewel. |
| texOrigin    | `vwc2(0,0)`              | If using a sprite sheet, this is the lower left corner of the rectangle associated with this gem. |
| texSize      | `vec2(1,1)`              | This is the width and height of the rectangle of the texture associated to this gem.
--]]
function addJewel(t)
    local m = t.mesh or mesh()
    local p = t.position or (m.size + 1)
    p = p + (1-p)%3
    local o = t.origin or vec3(0,0,0)
    local c = t.colour or t.color or color(223, 225, 124, 255)
    local as = t.aspect or 1
    local to = t.texOrigin or vec2(0,0)
    local ts = t.texSize or vec2(1,1)
    local a = {}
    a[1] = t.axis or vec3(0,1,0)
    if t.size then
        a[1] = a[1]:normalize()*t.size
    end
    local ax,ay,az = math.abs(a[1].x),math.abs(a[1].y),math.abs(a[1].z)
    if ax < ay and ax < az then
        a[2] = vec3(0,a[1].z,-a[1].y)
    elseif ay < az then
        a[2] = vec3(a[1].z,0,-a[1].x)
    else
        a[2] = vec3(a[1].y,-a[1].x,0)
    end
    a[3] = a[1]:cross(a[2])
    local la = a[1]:len()
    for i = 2,3 do
        a[i] = as*la*a[i]:normalize()
    end
    local n = t.sides or 12
    if p > m.size - 12*n then
        m:resize(p + 12*n-1)
    end
    __doJewel(m,p,n,o,a,c,to,ts)
    return p,p+12*n
end

--[[
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
    local ip = p
    local th = math.pi/n
    local cs = math.cos(th)
    local sn = math.sin(th)
    local h = (1 - cs)/(1 + cs)
    local k,b,c,d,nml,u,v,w,tb,tc,td,tu
    b = a[2]
    c = cs*a[2] + sn*a[3]
    d = -sn*a[2] + cs*a[3]
    tb = vec2(ts.x*.25,0)
    tc = cs*vec2(ts.x*.25,0) + sn*vec2(0,ts.y*.5)
    td = -sn*vec2(ts.x*.25,0) + cs*vec2(0,ts.y*.5)
    for i = 1,2*n do
        k = 2*(i%2) - 1
        for j = -1,1,2 do
            u = o+j*a[1]
            v = o+h*k*a[1]+b
            w = o-h*k*a[1]+c
            nml = j*(v-u):cross(w-u):normalize()
            tu = to+vec2(ts.x*(.5+j*.25),ts.y*.5)
            __addTriangle(m,p,u,v,w,col,col,col,nml,nml,nml,tu,tu+tb,tu+tc)
            p = p + 3
        end
        b = c
        c = cs*c + sn*d
        d = -sn*b + cs*d
        tb = tc
        tc = cs*tc + sn*td
        td = -sn*tb + cs*td
    end
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
| Option | Default | Description |
|:-------|:--------|:------------|
| `mesh`                     | new mesh | Mesh to use to add shape to. |
| `position`                 | end of mesh | Position in mesh to add shape at. |
| `colour`/`color` | color(148,105,50,255) | Colour or colours to use.  Can be a table of colours, one for each vertex of the cube. |
| `faces`        | all         | Which faces to render |
| `texOrigin`    | `vec2(0,0)` | Lower left corner of region on texture. |
| `texSize`      | `vec2(1,1)` | Width and height of region on texture. |

There are a few ways of specifying the dimensions of the "cube".

`centre`/`center`, `width`, `height`, `depth`, `size`.  This defines the "cube" by specifying a centre followed by the width, height, and depth of the cube (`size` sets all three).  These can be `vec3`s or numbers.  If numbers, they correspond to the dimensions of the "cube" in the `x`, `y`, and `z` directions respectively.  If `vec3`s, then are used to construct the vertices by adding them to the centre so that the edges of the "cube" end up parallel to the given vectors.

`startCentre`/startCenter`, `startWidth`, `startHeight`, `endCentre`/endCenter`, `endWidth`, `endHeight`.  This defined the "cube" by defining two opposite faces of the cube and then filling in the region in between.  The two faces are defined by their centres, widths, and heights.  The widths and heights can be numbers or `vec3`s exactly as above.

`cube`.  This is a table of eight vertices defining the cube.  The vertices are listed in binary order, in that if you picture the vertices of the standard cube of side length `1` with one vertex at the origin, the vertex with coordinates `(a,b,c)` is number a + 2b + 4c + 1 in the table (the `+1` is because lua tables are 1-based).
--]]
function addCube(t)
    local m = t.mesh or mesh()
    local p = t.position or (m.size + 1)
    p = p + (1-p)%3
    local c = t.colour or t.color or color(148, 105, 50, 255)
    if type(c) == "userdata" then
        c = {c,c,c,c,c,c,c,c}
    end
    local f = t.faces or CubeFaces
    local to = t.texOrigin or vec2(0,0)
    local ts = t.texSize or vec2(1,1)
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
    __doCube(m,p,f,v,c,to,ts)
    return p,p + 36
end

--[[
m mesh
p index of first vertex to be used
f table of faces of cube
v table of vertices of cube
c table of colours of cube (per vertex of cube)
to offset for this shape's segment of the texture
ts size of this shape's segment of the texture
--]]
function __doCube(m,p,f,v,c,to,ts)
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
        t = t + 1
    end
end

--[[
| Options | Defaults | Description |
|:--------|:---------|:------------|
| `mesh` | New mesh | Mesh to add shape to. |
| `position` | End of mesh | Position at which to add shape. |
| `origin`/`centre`/`center` | `vec3(0,0,0)` | Centre of sphere. |
| `axes` | Standard axes | Axes of sphere. |
| `size` | `1` | Radius of sphere (relative to axes). |
| `colour`/`color` | `color(48,104,159,255)` | Colour of sphere. |
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
    local c = t.colour or t.color or color(48, 104, 159, 255)
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
    __doSphere(m,p,o,a,0,step,n,0,step,2*n,c,f,to,ts)
    return p,p+12*n*(n-1)
end

--[[
| Options | Defaults | Description |
|:--------|:---------|:------------|
| `mesh` | New mesh | Mesh to add shape to. |
| `position` | End of mesh | Position at which to add shape. |
| `origin`/`centre`/`center` | `vec3(0,0,0)` | Centre of sphere. |
| `axes` | Standard axes | Axes of sphere. |
| `size` | `1` | Radius of sphere (relative to axes). |
| `colour`/`color` | `color(48,104,159,255)` | Colour of sphere. |
| `faceted` | `false` | Whether to render the sphere faceted or smoothed (not yet implemented). |
| `number` | `36` | Number of steps to use to render sphere (twice this for longitude. |
| `texOrigin` | `vec2(0,0)` | Origin of region in texture to use. |
| `texSize` | `vec2(0,0)` | Width and height of region in texture to use.|

Specifying the segment can be done in a variety of ways.

`startLatitude`, `endLatitude`, `deltaLatitude`, `startLongitude`, `endLongitude`, `deltaLongitude` specify the latitude and longitude for the segment relative to given axes (only two of the three pieces of information for each need to be given).

--]]
function addSphereSegment(t)
    local m = t.mesh or mesh()
    local p = t.position or (m.size + 1)
    p = p + (1-p)%3
    local o = t.origin or t.centre or t.center or vec3(0,0,0)
    local s = t.size or 1
    local c = t.colour or t.color or color(48, 104, 159, 255)
    local n = t.number or 36
    local a = t.axes or {vec3(1,0,0),vec3(0,1,0),vec3(0,0,1)}
    a[1],a[2],a[3] = s*a[1],s*a[2],s*a[3]
    local st,et,dt = __threeFromTwo(t.startLongitude,t.endLongitude,t.deltaLongitude,0,180,180)
    st = st/180*math.pi
    dt = dt/180*math.pi
    et = et/180*math.pi
    local sp,ep,dp = __threeFromTwo(t.startLatitude,t.endLatitude,t.deltaLatitude,0,360,360)
    sp = sp/180*math.pi
    dp = dp/180*math.pi
    ep = ep/180*math.pi
    local step = math.pi/n
    local nt = math.ceil(dt/step)
    local np = math.ceil(dp/step)
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
    if p > m.size - size then
        m:resize(p-1+size)
    end
    __doSphere(m,p,o,a,st,dt/nt,nt,sp,dp/np,np,c,f,to,ts)
    return p,p+size
end

--[[
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
                    l = math.floor((l-1)/3)+1
                    m:normal(p,(ver[l+1] - ver[l]):cross(ver[l+2] - ver[l]):normalize())
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
        table.insert(ends,1)
    end
    if st + nt*dt >= math.pi then
        table.insert(ends,0)
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
                    m:normal(p,(ver[2]-ver[1]):cross(ver[3]-ver[1]):normalize())
                else
                    m:normal(p,ver[k]:normalize())
                end
                -- tx = vec2((v[2]-sp)/ep,i + (1-2*i)*(v[1]-st)/et)

                m:texCoord(p,tex[k])
                p = p + 1
            end
        end
    end
end

-- function extendMesh()
    local mt = getmetatable(mesh())

    mt.addJewel = function(m,t)
        t = t or {}
        return addJewel({
            mesh = m,
            position = t.position,
            axis = t.axis,
            origin = t.origin,
            sides = t.sides,
            colour = t.colour or t.color,
            texSize = t.texSize,
            texOrigin = t.texOrigin
        })
    end
    
    mt.addCube = function(m,t)
        t = t or {}
        return addCube({
            mesh = m,
            position = t.position,
            cube = t.cube,
            centre = t.centre or t.center,
            width = t.width,
            height = t.height,
            depth = t.depth,
            size = t.size,
            startCentre = t.startCentre or t.startCenter,
            startWidth = t.startWidth,
            startHeight = t.startHeight,
            endCentre = t.endCentre or t.endCenter,
            endWidth = t.endWidth,
            endHeight = t.endHeight,
            colour = t.colour or t.color,
            faces = t.faces,
            texSize = t.texSize,
            texOrigin = t.texOrigin
        })
    end

    mt.addSphere = function(m,t)
        t = t or {}
        return addSphere({
            mesh = m,
            position = t.position,
            origin = t.origin,
            size = t.size,
            colour = t.colour or t.color,
            texSize = t.texSize,
            texOrigin = t.texOrigin,
            number = t.number,
            faceted = t.faceted
        })
    end

    mt.addSphereSegment = function(m,t)
        t = t or {}
        return addSphereSegment({
            mesh = m,
            position = t.position,
            origin = t.origin,
            size = t.size,
            colour = t.colour or t.color,
            texSize = t.texSize,
            texOrigin = t.texOrigin,
            number = t.number,
            faceted = t.faceted,
            startLatitude = t.startLatitude,
            deltaLatitude = t.deltaLatitude,
            endLatitude = t.endLatitude,
            startLongitude = t.startLongitude,
            deltaLongitude = t.deltaLongitude,
            endLongitude = t.endLongitude,
        })
    end
-- end


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
