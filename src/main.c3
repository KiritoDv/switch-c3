module nswitch;

import sdl;

fn void draw_rects(sdl::Renderer* renderer, int x, int y) @export("draw_rects"){
	sdl::setRenderDrawColor(renderer, 255, 0, 0, 255);
    sdl::Rect r = {x, y, 64, 64};
    sdl::renderFillRect(renderer, r);

    // G
    sdl::setRenderDrawColor(renderer, 0, 255, 0, 255);
    sdl::Rect g = {x + 64, y, 64, 64};
    sdl::renderFillRect(renderer, g);

    // B
    sdl::setRenderDrawColor(renderer, 0, 0, 255, 255);
    sdl::Rect b = {x + 128, y, 64, 64};
    sdl::renderFillRect(renderer, b);
}

fn int main(String[] args) @export("main") {
	sdl::Event event;
	sdl::Window* window;
	sdl::Renderer* renderer;
	int done = 0;
	int x = 0;
	int w = 1920;
	int h = 1080;

	if(sdl::init(sdl::INIT_VIDEO | sdl::INIT_JOYSTICK) < 0){
		sdl::log("SDL_Init: %s\n", sdl::getError());
		return -1;
	}

	window = sdl::createWindow("sdl2_gles", 0, 0, w, h, 0);

	if(!window){
		sdl::log("SDL_CreateRenderer: %s\n", sdl::getError());
		sdl::quit();
		return -1;
	}

	renderer = sdl::createRenderer(window, 0, (uint) sdl::RENDERER_ACCELERATED | (uint) sdl::RENDERER_PRESENTVSYNC);

	if(!renderer){
		sdl::log("SDL_CreateRenderer: %s\n", sdl::getError());
		sdl::quit();
		return -1;
	}

	for(int i = 0; i < 2; i++){
		if(sdl::joystickOpen(i) == null){
			sdl::log("SDL_JoystickOpen: %s\n", sdl::getError());
			sdl::quit();
		}
	}

	while(!done) {
		sdl::setRenderDrawColor(renderer, 0, 0, 0, 255);
		sdl::renderClear(renderer);

		sdl::setRenderDrawColor(renderer, 255, 100, 100, 255);
		sdl::getWindowSize(window, &w, &h);
		sdl::Rect f = { 0, 0, w, h };
		sdl::renderFillRect(renderer, f);

		// draw_rects(renderer, 0, 0);
		sdl::setRenderDrawColor(renderer, 0, 255, 0, 255);
		sdl::Rect r = {0, 0, 64, 64};
		sdl::renderDrawRect(renderer, r);

		sdl::renderPresent(renderer);
	}

	sdl::destroyRenderer(renderer);
	sdl::destroyWindow(window);
	sdl::quit();

	return 0;
}
