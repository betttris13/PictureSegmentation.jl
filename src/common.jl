#function used for adjusting strength of pixel
function g(x,maxC)
    return 1-(x/maxC)
end

#find maximum colour vector
function find_maxC(img)
    maxC = 0
    for i in CartesianIndices(img)
        C = sqrt(img[i].r^2 + img[i].g^2  + img[i].b^2)
        if C > maxC
            maxC = C
        end
    end
    return maxC
end

function count_enemy(Nl,target_pixel::CartesianIndex,NBound)
    num_enemy = 0
    @inbounds for j in CartesianIndices(NBound)
         if j != CartesianIndex(target_pixel) && Nl[j]!=Nl[target_pixel] && Nl[j]!=0
            num_enemy+=1
        end
    end
    return num_enemy
end

#std update of pixel
function update_pixel(Nθ,Nθₜ₊₁,Nl,Nlₜ₊₁,Nimg,NE,target_pixel::CartesianIndex,maxC,t1,count,Nbound,changedₜ₊₁)
    @inbounds for j in CartesianIndices(Nbound)
        Cdiff=Nimg[target_pixel]-Nimg[j]
        absCdiff=sqrt(Cdiff.r^2+Cdiff.g^2+Cdiff.b^2)
        adjusted_strenth = g(absCdiff,maxC)*Nθ[j]
        change = false
        if adjusted_strenth>Nθ[target_pixel] && NE[j]<t1 && j != target_pixel
            Nlₜ₊₁[target_pixel]=Nl[j]
            Nθₜ₊₁[target_pixel]=adjusted_strenth
            count +=1
            if change == false
                push!(changedₜ₊₁,Nbound)
                change = true
            end
        end
    end
    return Nθₜ₊₁,Nlₜ₊₁,count,changedₜ₊₁
end

#update of pixel if sorounded by to many enemies
function occupy_pixel(Nθ,Nθₜ₊₁,Nl,Nlₜ₊₁,Nimg,target_pixel::CartesianIndex,maxC,count,Nbound,changedₜ₊₁)
    θtemp = 1.0
    imgtemp = Nimg[target_pixel]
    ltemp = Nl[target_pixel]
    @inbounds for j in CartesianIndices(Nbound)
        if j != target_pixel && Nθ[j] < θtemp && Nl[j] != Nl[target_pixel]
            θtemp = Nθ[j]
            imgtemp = Nimg[j]
            ltemp = Nl[j]
        end
    end
    Cdiff=Nimg[target_pixel]-imgtemp
    absCdiff=sqrt(Cdiff.r^2+Cdiff.g^2+Cdiff.b^2)
    Nθₜ₊₁[target_pixel]=g(absCdiff,maxC)*θtemp
    Nlₜ₊₁[target_pixel]=ltemp
    count+=1
    push!(changedₜ₊₁,Nbound)
    return Nθₜ₊₁,Nlₜ₊₁,count,changedₜ₊₁
end

#sets initial strengths
function set_strength(label)
    θ = zeros(Float64,axes(label))
    for i in CartesianIndices(label)
        if label[i]>0
            θ[i]=1.0
        end
    end
    return θ
end
