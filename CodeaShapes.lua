-- MeshShapes

-- Use this function to perform your initial setup
function setup()
    extendMesh()
    m = mesh()
    m.shader = lighting()
    m.shader.ambient = .5
    m.shader.light = vec3(0,1,1):normalize()
    m.shader.useTexture = 1
    local w,h = spriteSize("Cargo Bot:Crate Blue 1")
    img = image(10*w,h)
    setContext(img)
    spriteMode(CORNER)
    sprite("Cargo Bot:Crate Yellow 1",0,0)
    sprite("Cargo Bot:Crate Yellow 2",w,0)
    sprite("Cargo Bot:Crate Green 1",2*w,0)
    sprite("Cargo Bot:Crate Blue 2",3*w,0)
    sprite("Cargo Bot:Crate Red 2",4*w,0)
    sprite("Cargo Bot:Crate Green 2",5*w,0)
    sprite("Cargo Bot:Crate Blue 3",6*w,0)
    sprite("Cargo Bot:Crate Red 3",7*w,0)
    sprite("Cargo Bot:Crate Green 3",8*w,0)
    sprite("Cargo Bot:Crate Red 1",9*w,0)
    setContext()
    m.texture = img
    print("Initial mesh size:", m.size)
    print("Returned values of addJewel:", m:addJewel({
        texOrigin = vec2(0,0),
        texSize = vec2(.2,1)
    }))
    print("Returned values of addCube:", m:addCube({
        centre = vec3(2,0,0),
        texOrigin = vec2(.2,0),
        texSize = vec2(.8,1)
    }))
    print("Final mesh size:",m.size)
    parameter.number("rot_x",0,360,0)
    parameter.number("rot_y",0,360,0)
    parameter.number("rot_z",0,360,0)
    parameter.number("size",-1,2,0)
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

local __doJewel, __addTriangle

function addJewel(t)
    local m = t.mesh or mesh()
    local p = t.position or (m.size + 1)
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
    return __doJewel(m,p,n,o,a,c,to,ts)
end

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
    return ip, p
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
    vec2(0,0),vec2(.125,0),vec2(0,1),vec2(.125,1)
}
function addCube(t)
    local m = t.mesh or mesh()
    local p = t.position or (m.size + 1)
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
        local w,h,d = t.width or 1, t.height or 1, t.depth or 1
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
        m:resize(p + 36)
    end
    __doCube(m,p,f,v,c,to,ts)
    return p + 36
end

function __doCube(m,p,f,v,c,to,ts)
    local n,t,tv
    t = 0
    for k,w in ipairs(f) do
        n = (v[w[3]] - v[w[1]]):cross(v[w[2]] - v[w[1]]):normalize()
        for i,u in ipairs({1,2,3,2,3,4}) do
            m:vertex(p,v[w[u]])
            m:color(p,c[w[u]])
            m:normal(p,n)
            tv = CubeTex[u] + t*vec2(.125,0)
            tv.x = tv.x * ts.x
            tv.y = tv.y * ts.y
            m:texCoord(p, to + tv)
            p = p + 1
        end
        t = t + 1
    end
end

function extendMesh()
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
end


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
