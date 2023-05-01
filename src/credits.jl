using CairoMakie
using FileIO
CairoMakie.activate!()

a1 = load("./imgs/globes_lights_camera_t.png");
res = size(a1)
noto_sans_bold = assetpath("fonts", "NotoSans-Bold.ttf")
logo = load("logos/MPI_BGC_wide_E_neg_cmyk.png")
logo = logo[15:end-15, 25:end-25];
function add_axis_inset(pos=fig[1, 1]; halign, valign, width=Relative(0.5),
    height=Relative(0.45), alignmode=Mixed(left = 5, right=5), 
    bgcolor=:transparent)

    inset_box = Axis(pos; width, height, halign, valign, alignmode, 
        aspect= DataAspect(),
        xticklabelsize=12, yticklabelsize=12, backgroundcolor=bgcolor)
    # bring content upfront
    translate!(inset_box.blockscene, 0, 0, 100)
    return inset_box
end

function showImg(imageOut; resolution=res[end:-1:1])
    textsize = 24
    fig = Figure(resolution=resolution)
    fig.layout.alignmode[] = Outside(0)
    ax = Axis(fig[1, 1], aspect=DataAspect()
        )
    image!(ax, rotr90(imageOut))
    #text!(ax, "Source: MOD13C1. MOD15A2H. ECMWF/ERA5", position=(25, 80); color=:white, textsize)
    #text!(ax, "MPI-BGI Project Vis", position=(25, 35); color=:white, font= noto_sans_bold, textsize)
    text!(ax, 25, 780, text=rich("Created by ",
        rich("Lazaro Alonso\n\n", color=:white, font=:regular),
        rich("MPI-BGI ", rich("Project Vis", font=:regular), font=:bold),
        color=:grey95, fontsize=textsize, font=:bold)
        )
    axlogo = add_axis_inset(fig[1, 1]; halign=0.99, valign=-0.125,
        width=Relative(0.3), height=Relative(0.3),
        #alignmode=Mixed(left=5, right=15, bottom=-10, top=0),
        bgcolor = :transparent)
    imgs = image!(axlogo, rotr90(logo), transparency=true)
    hidedecorations!(axlogo)
    hidespines!(axlogo)
    hidedecorations!(ax)
    hidespines!(ax)
    resize_to_layout!(fig)
    fig
end

fig = showImg(a1);
save("./imgs/earths_creditst.png", fig)