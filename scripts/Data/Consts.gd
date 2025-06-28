extends Node

# 场景
enum SCENES {
	START_UP,
	LEVEL_SELECT,
	SCENE,
	ABOUT,
}

# 物件
enum ITEMS {
	BOOK,
	CLOSET,
	PAINTING,
	CAMERA
}

# 障碍物
enum BLOCKS {
	BEAR,
	LIGHT,
	QUILT,
	GEAR
}

# 交互事件
signal ROLLBACK_START()
signal ROLLBACK_END()
