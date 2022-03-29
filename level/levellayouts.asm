# Level layout data

.eqv TILE_WIDTH 8	# Must divide DISPLAY_WIDTH
.eqv TILE_HEIGHT 8	# Must divide DISPLAY_HEIGHT
.eqv LAYOUT_WIDTH 16	# = DISPLAY_WIDTH / TILE_WIDTH
.eqv LAYOUT_HEIGHT 8	# = DISPLAY_HEIGHT / TILE_HEIGHT

## typedef struct level_layout_tile {
## 	sprite* graphics;
## 	int collision; // 0 = no collision, 1 = collision
## } level_layout_tile;

## typedef struct level_layout {
## 	level_layout_tile (*tiles)[LAYOUT_WIDTH * LAYOUT_HEIGHT];
## } level_layout;

.eqv SIZEOF_level_layout_tile 8

.eqv level_layout_tile.graphics 0
.eqv level_layout_tile.collision 4

.data

level_0:	.word	t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_floor_pushbutton, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground
