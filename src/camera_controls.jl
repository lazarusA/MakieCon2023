using LinearAlgebra
function azelrad(azim, elev, radius)
    x = radius * cosd(elev) * cosd(azim)
    y = radius * cosd(elev) * sind(azim)
    z = radius * sind(elev)
    Vec3f(x, y, z)
end

function camera_controls!(ax; azimuth=90, elevation=20, nearclip=0.001,
    perspectiveness=0.5, lookat =Vec3f(0.0, 0.0, 0.0),
    ang_max=90, ang_min=0.5,zoom=1.0)

    @assert 0.1 <= perspectiveness <= 1
    angle = ang_min + (ang_max - ang_min) * perspectiveness
    cam_distance = sqrt(3) / sind(angle / 2)
    cam = cameracontrols(ax.scene)
    zoom!(ax.scene, cam, zoom)

    cam.lookat[] = lookat
    cam.eyeposition[] = lookat + azelrad(azimuth, elevation, cam_distance)
    cam_forward = normalize(lookat - cam.eyeposition[])
    world_up = Vec3f(0, 0, 1)
    cam_right = cross(cam_forward, world_up)
    cam.upvector[] = cross(cam_right, cam_forward)
    cam.near[] = nearclip
    #cam.fov[] = angle / zoom
    #farclip = 2 * cam_distance
    #cam.far[] = farclip
end