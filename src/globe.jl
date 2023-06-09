using GLMakie, FileIO, Downloads
GLMakie.activate!()
path = "https://earthobservatory.nasa.gov/ContentFeature/BlueMarble/Images/"
img = "land_ocean_ice_cloud_2048.jpg"
earth_img = load(Downloads.download(joinpath(path, img)))
image(rotr90(earth_img))

mesh(Sphere(Point3f(0), 1);
    color=earth_img,
    )

fig, ax, obj=mesh(Sphere(Point3f(0), 1);
    color=earth_img,
    figure=(; resolution=(800,800), backgroundcolor=:grey10),
    axis=(; show_axis=false))

meshscatter!(Point3f(0,0,1.1); color=:gold)
zoom!(ax.scene, cameracontrols(ax.scene), 0.65)
fig

color=:red
scatter(rand(10); color)
scatter!(rand(10); color)
scatter!(rand(10); color)
current_figure()