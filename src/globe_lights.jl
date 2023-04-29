## by Lazaro Alonso
using RPRMakie, RadeonProRender
using Colors
using RPRMakie.GeometryBasics: Tesselation, uv_normal_mesh
begin
    RPRMakie.activate!(
        resource=RPR.RPR_CREATION_FLAGS_ENABLE_CPU, # CPU -> GPU0 if available
        plugin=RPR.Northstar, iterations=50
        )
    bg_color = [colorant"grey15"][:,:]
    lights = [
        EnvironmentLight(1.0, bg_color),
        PointLight(Vec3f(0, 2, 1), 10 .* RGBf(252/255, 94/255, 3/255)), # red-ish
        PointLight(Vec3f(2, 0, 1), 10 .* RGBf(0.5, 0.5, 1)), # blue-ish
        PointLight(Vec3f(1.95, 1.95, 0.2), colorant"gold"), # gold
        ]
    floor = Rect3f(Vec3f(0), Vec3f(2,2,0.05))
    sphere = Sphere(Point3f(1.5,1.5,0.5),0.35)
    sphere = uv_normal_mesh(Tesselation(sphere, 128))

    fig = Figure(; resolution=(800, 800))
    ax = LScene(fig[1, 1]; show_axis=false, scenekw=(; lights=lights))
    screen = RPRMakie.Screen(ax.scene)
    matsys = screen.matsys
    mesh!(ax, floor; material = RPR.DiffuseMaterial(matsys), color=:grey10)
    mesh!(ax, sphere; color =:dodgerblue)
    zoom!(ax.scene, cameracontrols(ax.scene), 0.8)
    # save render
    imageOut = colorbuffer(screen)
    save("./imgs/floor_sphere_lights.png", imageOut)
end