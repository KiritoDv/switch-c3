module nswitch;

import sdl;

fn void draw_rects(sdl::Renderer* renderer, int x, int y) {
	sdl::setRenderDrawColor(renderer, 255, 0, 0, 255);
    sdl::Rect r = {x, y, 64, 64};
    sdl::renderFillRect(renderer, &r);

    // G
    sdl::setRenderDrawColor(renderer, 0, 255, 0, 255);
    sdl::Rect g = {x + 64, y, 64, 64};
    sdl::renderFillRect(renderer, &g);

    // B
    sdl::setRenderDrawColor(renderer, 0, 0, 255, 255);
    sdl::Rect b = {x + 128, y, 64, 64};
    sdl::renderFillRect(renderer, &b);
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
		while(sdl::pollEvent(&event)){
			switch(event.type){
				case sdl::JOYAXISMOTION:
					sdl::log("Joystick %d axis %d value: %d\n",
                            event.jaxis.which,
                            event.jaxis.axis, event.jaxis.value);
					break;
				case sdl::JOYBUTTONDOWN:
					sdl::log("Joystick %d button %d down\n",
                            event.jbutton.which, event.jbutton.button);
                    // https://github.com/devkitPro/SDL/blob/switch-sdl2/src/joystick/switch/SDL_sysjoystick.c#L52
                    // seek for joystick #0
                    if (event.jbutton.which == 0) {
                        if (event.jbutton.button == 0) {
                            // (A) button down
                            if(w == 1920) {
                                sdl::setWindowSize(window, 1280, 720);
                            } else {
                                sdl::setWindowSize(window, 1920, 1080);
                            }
                        } else if (event.jbutton.button == 10) {
                            // (+) button down
                            done = 1;
                        }
                    }
					break;
				default:
					break;
			}
		}
		sdl::setRenderDrawColor(renderer, 0, 0, 0, 255);
		sdl::renderClear(renderer);

		sdl::setRenderDrawColor(renderer, 111, 111, 111, 255);
		sdl::getWindowSize(window, &w, &h);
		sdl::Rect f = { 0, 0, w, h };
		sdl::renderFillRect(renderer, &f);

		draw_rects(renderer, x, 0);
        draw_rects(renderer, x, h - 64);

		sdl::renderPresent(renderer);

		x++;
        if (x > w - 192) {
            x = 0;
        }
	}

	sdl::destroyRenderer(renderer);
	sdl::destroyWindow(window);
	sdl::quit();

	return 0;
}
