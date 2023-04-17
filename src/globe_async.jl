using GLMakie, FileIO, Downloads
using YAXArrays, Zarr, NetCDF
include("utils.jl")
# get some data
port = "https://s3.bgc-jena.mpg.de:9000/"
bucket = "esdl-esdc-v2.1.1"
store = "esdc-8d-0.25deg-1x720x1440-2.1.1.zarr"
path = joinpath(port, bucket, store)

c = Cube(open_dataset(zopen(path,consolidated=true)))
c = c[Variable="air_temperature_2m"] # get one Variable

sub_c = c[time = (Date("2013-01-01"), Date("2018-12-31"))] # select time span
sub_c = readcubedata(sub_c) # Since is small enough, let's fetch everything into memory.

lon, lat = sub_c.lon, sub_c.lat
data = sub_c.data
d = data[:,:,1]
data_ext = ex_data(lon,lat,d) # for a closed surface
lonext = cat(collect(lon), lon[1], dims = 1)
x,y,z = getSphere(lonext, lat, data_ext; h=0,k=0,m=0)

d = Observable(data_ext .- 273.15)

fig, ax, obj=surface(x, y, z;
    color=d,
    #colormap = Reverse(:Hiroshige),
    colormap = [:white, :snow2, :snow3, :grey50, :dodgerblue, :orangered, :orange, :yellow, :gold],
    colorrange=(-40,40),
    shading=false,
    figure=(; resolution=(850,800)),
    axis=(; show_axis=false))
Colorbar(fig[1,2], obj, height=Relative(0.5))
zoom!(ax.scene, cameracontrols(ax.scene), 0.65)
fig

# always running
run = Button(fig[1,2, Top()]; label = "Play")

isrunning = Observable(false)
on(run.clicks) do clicks
    isrunning[] = !isrunning[]
    @async while isrunning[]
        isopen(fig.scene) || break # ensures computations stop if closed window
        for t in axes(data,3)
            d[] = ex_data(lon,lat,data[:,:,t]) .- 273.15
            sleep(0.01)
        end
    end
end
