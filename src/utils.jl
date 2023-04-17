function getSphere(lon, lat, data; r=1,h=0,k=0,m=0)
    xyz= zeros(size(data)..., 3)
    for (i,lon) in enumerate(lon), (j,lat) in enumerate(lat)
        xyz[i,j,1] = h + r * cosd(lat) * cosd(lon)
        xyz[i,j,2] = k + r * cosd(lat) * sind(lon)
        xyz[i,j,3] = m + r * sind(lat)
    end
    return xyz[:,:,1], xyz[:,:,2], xyz[:,:,3]
end

function ex_data(lon,lat,d)
    dataext = begin
        tmp_d = zeros(size(lon)[1] + 1, size(lat)[1])
        tmp_d[1:size(lon)[1], :] = d
        tmp_d[size(lon)[1]+1, :] = d[1, :]
        tmp_d
    end
    return dataext
end