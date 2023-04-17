using GLMakie, FileIO, Downloads
using YAXArrays, Zarr, NetCDF
# get some data
port = "https://s3.bgc-jena.mpg.de:9000/"
bucket = "esdl-esdc-v2.1.1"
store = "esdc-8d-0.25deg-1x720x1440-2.1.1.zarr"
path = joinpath(port, bucket, store)

c = Cube(open_dataset(zopen(path,consolidated=true)))
c = c[Variable="air_temperature_2m", lon=(-10,33), lat = (35,70)] # get one Variable and Europe

sub_c = c[time = (Date("2016-01-01"), Date("2018-12-31"))] # select time span
sub_c = readcubedata(sub_c) # Since is small enough, let's fetch everything into memory.
lon, lat = sub_c.lon, sub_c.lat
tempo = sub_c.time
data = sub_c.data

contour(lon, lat, 1:size(tempo,1), data .- 273.15; levels=50,
    colormap = [:white, :snow2, :snow3, :grey50, :dodgerblue, :orangered, :orange, :yellow, :gold],
    colorrange=(-40,40),
    figure = (; resolution = (800,800)),
    axis = (; show_axis=false)
    )

volume(lon, lat, 1:size(tempo,1), data .- 273.15;
    colormap = [:white, :snow2, :snow3, :grey50, :dodgerblue, :orangered, :orange, :yellow, :gold],
    colorrange=(-40,40),
    figure = (; resolution = (800,800)),
    axis = (; show_axis=true)
    )

# with scatters    
pixels = [Point3f(t, lo, la) for t in 1:size(tempo,1)÷2 for lo in lon for la in lat];
t2m = [data[i,j,t] for t in 1:size(tempo,1)÷2 for (i,lo) in enumerate(lon) for (j,la) in enumerate(lat)];

δlo = abs(lon[2] - lon[1])
δla = abs(lat[2] - lat[1])
δt = 1
marker = Rect3f(Vec3f(-0.5), Vec3f(1))

meshscatter(pixels; marker,
    color=t2m .- 273.15,
    colorrange = (-40,40),
    colormap = [:white, :snow2, :snow3, :grey50, :dodgerblue, :orangered, :orange, :yellow, :gold],
    markersize = Vec3f(δt -0.2δt, δlo -0.2δlo, δla -0.2δla))
