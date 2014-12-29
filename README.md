Codea-Shapes
============

Defines methods for adding standard shapes in Codea.

addJewel
========

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

addCube
=======

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

addSphere
=========

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

addSphereSegment
================

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
| `solid` | `true` | Whether to make the sphere solid by filling in the internal sides. |
| `texOrigin` | `vec2(0,0)` | Origin of region in texture to use. |
| `texSize` | `vec2(0,0)` | Width and height of region in texture to use.|

Specifying the segment can be done in a variety of ways.

`startLatitude`, `endLatitude`, `deltaLatitude`, `startLongitude`, `endLongitude`, `deltaLongitude` specify the latitude and longitude for the segment relative to given axes (only two of the three pieces of information for each need to be given).

addCylinder
===========

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

addPyramid
==========

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

