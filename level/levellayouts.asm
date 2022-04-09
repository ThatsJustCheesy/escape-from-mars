# Level layout data

.eqv TILE_WIDTH 8	# Must divide DISPLAY_WIDTH
.eqv TILE_HEIGHT 8	# Must divide DISPLAY_HEIGHT
.eqv LAYOUT_WIDTH 16	# = DISPLAY_WIDTH / TILE_WIDTH
.eqv LAYOUT_HEIGHT 16	# = DISPLAY_HEIGHT / TILE_HEIGHT

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

## typedef struct level_objects {
## 	int count;
## 	object* objects[count];
## } level_objects;

.eqv level_objects.count 0
.eqv level_objects.objects 4

.data

level_0:	.word	t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_ground, t_empty, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_empty, t_empty, t_ground, t_ground, t_ground, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground

level_1:	.word	t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_collide_when_inactive, t_collide_when_inactive, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_collide_when_inactive, t_collide_when_inactive, t_collide_when_inactive, t_ground, t_ground, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_collide_when_inactive, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_collide_when_inactive, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground
level_1_objects:	.word	3, o_l1_ender, o_l1_cloner, o_l1_activator
o_l1_ender:	108, 108, 116, 116, sprite_ender, update_ender
o_l1_cloner:	30, 16, 38, 24, sprite_cloner, update_cloner
o_l1_activator:	108, 24, 116, 32, sprite_activator, update_activator

level_2:	.word	t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_collide_when_inactive, t_collide_when_inactive, t_collide_when_inactive, t_collide_when_inactive, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_collide_when_active, t_collide_when_active, t_collide_when_active, t_collide_when_active, t_collide_when_active, t_collide_when_active, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_empty, t_empty, t_ground, t_ground, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_empty, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground, t_ground
level_2_objects:	.word	4, o_l2_ender, o_l2_cloner_1, o_l2_cloner_2, o_l2_activator
o_l2_ender:	60, 8, 68, 16, sprite_ender, update_ender
o_l2_cloner_1:	26, 38, 34, 46, sprite_cloner, update_cloner
o_l2_cloner_2:	94, 38, 102, 46, sprite_cloner, update_cloner
o_l2_activator:	80, 80, 88, 88, sprite_activator, update_activator
