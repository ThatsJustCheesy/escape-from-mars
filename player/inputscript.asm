## typedef struct input_script {
## 	input_script_step steps[];
## } input_script;

## typedef struct input_script_step {
## 	int frame_index;
## 	short input;
## } input_script_step;

.eqv SIZEOF_input_script_step 8

.eqv input_script_step.frame_index 0
.eqv input_script_step.input 4

.data

current_input_script:	.word	0	# input_script*
current_input_script_cursor:	.word	0	# input_script*

current_frame_index:	.word	0
