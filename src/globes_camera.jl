## by Lazaro Alonso
using RPRMakie, RadeonProRender
using Colors, FileIO, Downloads
using RPRMakie.GeometryBasics: Tesselation, uv_normal_mesh
using Random

include("camera_controls.jl")

path = "https://earthobservatory.nasa.gov/ContentFeature/BlueMarble/Images/"
img = "land_ocean_ice_cloud_2048.jpg"
earth_img = load(Downloads.download(joinpath(path, img)));
earth_img = rotr90(earth_img)[:,end:-1:1]

points = Point3f.([[1.0,-0.5,0.28], [1.3,-0.8,1.2], [0.7,-0.5,1.0], [0.0,-0.2,0.28],
    [-1.0,-0.5,0.28], [-1.3,-0.8,1.2], [-0.5,-1,1.0], [0.2, -1, 0.8],
    [0.7, -1, 1.45], [-0.85, -1, 1.45],[0.0, -1.25, 1.45], [-1.5,-0.8,0.12],
    [-0.6,-1.2,0.12], [0.45,0.0,0.17],[1.5,-0.7,0.17], [1.5,-1,0.65],
    [0.6,-1,0.55], [-0.5,-1,0.55], [-1.1,-1.25,0.75], [-1.5,-0.8,0.6]])

radius = [0.25, 0.2, 0.15, 0.25, 0.25, 0.2, 0.25, 0.25, 0.2, 0.15, 0.125,
    0.1, 0.1, 0.15, 0.15, 0.1, 0.1, 0.1, 0.2, 0.1]

floor = Rect3f(Vec3f(-4,-2,0.0), Vec3f(8,4,0.01))
wall = Rect3f(Vec3f(-4,-2.1,0.0), Vec3f(8,0.1,2))
sphere = Sphere(Point3f(0,0,1.1),0.3)
sphere = uv_normal_mesh(Tesselation(sphere, 128))

Random.seed!(123)
s_range = -4:0.01:4
s = size(s_range,1)
linea_1 = [Point3f(i,-2, (3.5*(s-idx)/s -0.7) +0.5rand()*(s-idx)/s) for (idx, i) in enumerate(s_range)]
linea_2 = [Point3f(i,-2, (1.8*(s-idx)/s -0.3) +0.35rand()*(s-idx)/s) for (idx, i) in enumerate(s_range)]
linea_3 = [Point3f(i,-2, 0.1rand()+0.1) for (idx, i) in enumerate(s_range)]

begin
    Random.seed!(423)
    RPRMakie.activate!(
        resource=RPR.RPR_CREATION_FLAGS_ENABLE_CPU, # CPU -> GPU0 if available
        plugin=RPR.Northstar, iterations=500
        )
    bg_color = [colorant"white"][:,:]
    lights = [
        EnvironmentLight(1.0, bg_color),
        PointLight(Vec3f(-4, 0, 1), 45 .* RGBf(252/255, 94/255, 3/255)), # red-ish
        PointLight(Vec3f(4, 0, 1), 45 .* RGBf(0.5, 0.5, 1)), # blue-ish
        #PointLight(Vec3f(0, 0, 3), 2*colorant"gold"), # gold
        ]

    fig = Figure(; resolution=(1600, 900))
    ax = LScene(fig[1, 1]; show_axis=false, scenekw=(; lights=lights))
    screen = RPRMakie.Screen(ax.scene)
    matsys = screen.matsys

    mesh!(ax, floor; material=RPR.Glass(matsys))
    mesh!(ax, wall; color=:grey40, material=RPR.DiffuseMaterial(matsys))
    lines!(ax, linea_1; color = :white, linewidth=1.5)
    lines!(ax, linea_2; color = :white, linewidth=2.5)
    lines!(ax, linea_3; color = :white, linewidth=1.0)
    [mesh!(ax, Sphere(p, radius[i]); color = circshift(earth_img, (rand(0:2048÷3:2048),0)))
        for (i,p) in enumerate(points)]
    camera_controls!(ax; zoom = 0.5, elevation=5,
        lookat =Vec3f(0.0, 0.0, 0.8))
    # save render
    imageOut = colorbuffer(screen)
    save("./imgs/globes_lights_camera_t.png", imageOut)
end