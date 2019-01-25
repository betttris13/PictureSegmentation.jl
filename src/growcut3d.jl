function segment_image(Algorithm::GrowCut,imgIn::AbstractArray{T,3} where T <: RGB, label::Array{Int}, t1::Int=27, t2::Int=27; max_iter::Int=1000, converge_at::Int=1)
    #initilize values
    img=RGB{Float64}.(imgIn)
    maxC = find_maxC(img)
    l = copy(label)
    E = zeros(Int, axes(img))
    θ = set_strength(l)
    lₜ₊₁ = copy(label)
    Eₜ₊₁ = zeros(Int, axes(img))
    θₜ₊₁ = set_strength(l)
    regions=maximum(label)
    iter = 0
    count = length(img)
    changed=Array{Tuple{UnitRange{Int},UnitRange{Int},UnitRange{Int}},1}(undef,1)
    changedₜ₊₁=Array{Tuple{UnitRange{Int},UnitRange{Int},UnitRange{Int}},1}(undef,0)
    changed[1]=1:size(img)[1],1:size(img)[2],1:size(img)[3]

    #iterate till convergance or maximum iterations reached
    while count > converge_at && iter < max_iter
        iter+=1
        @show iter, count
        count = 0
        copyto!(θₜ₊₁,θ)
        copyto!(lₜ₊₁,l)
        copyto!(Eₜ₊₁,E)

        #loop through active pixel neighbourhoods (all pixels on first iteration)
        for j in CartesianIndices(changed)
            @inbounds for i in CartesianIndices(changed[j])
                Nbound=max(i[1]-1,1):min(i[1]+1,axes(img)[1][end]),max(i[2]-1,1):min(i[2]+1,axes(img)[2][end]),max(i[3]-1,1):min(i[3]+1,axes(img)[3][end])
                Eₜ₊₁[i]=count_enemy(l,i,Nbound)
                if Eₜ₊₁[i] < t2
                    θₜ₊₁,lₜ₊₁,count,changedₜ₊₁=update_pixel(θ,θₜ₊₁,l,lₜ₊₁,img,E,i,maxC,t1,count,Nbound,changedₜ₊₁)
                else
                    θₜ₊₁,lₜ₊₁,count,changedₜ₊₁=occupy_pixel(θ,θₜ₊₁,l,lₜ₊₁,img,i,maxC,count,Nbound,changedₜ₊₁)
                end
            end
        end

        #update values
        #changed=changedₜ₊₁
        changedₜ₊₁=similar(changedₜ₊₁,0)
        E=Eₜ₊₁
        θ=θₜ₊₁
        l=lₜ₊₁
    end
    return l
end
