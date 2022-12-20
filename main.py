import math
import moderngl_window as mglw
import numpy as np

class App(mglw.WindowConfig):
    title = "Conway's game of life"
    width = 1600
    height = 900
    window_size = width, height
    resource_dir = 'programs'
    vsync = True

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.prog = self.load_program(vertex_shader='vert.glsl',
                                      fragment_shader='frag.glsl')
        self.compute = self.load_compute_shader(path='comp.glsl')
        self.compute['texture_buffer'] = 0

        data = np.random.randint(0.,2.,(self.width,self.height,4)).astype('f4')

        self.texture = self.ctx.texture(size=self.window_size,components=4,data=data.tobytes(),dtype='f4')
        self.quad = mglw.geometry.quad_fs()

    def render(self, time, frame_time):
        self.ctx.clear()

        w, h = self.texture.size
        gw, gh = 16, 16
        nx, ny, nz = math.ceil(w/gw), math.ceil(h/gh), 1

        self.texture.bind_to_image(0, read=True, write=True)
        self.compute.run(nx, ny, nz)

        self.texture.use(location=0)
        self.quad.render(self.prog)


if __name__ == '__main__':
    mglw.run_window_config(App)

