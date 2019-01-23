function set_seed_pixels(labels::Array{Int,2}, img::AbstractArray; suppress_feedback::Bool=false)
    scene = Scene()
    image!(img, show_axis = false)
    clicks = Node(Point2f0[])
    region = 1
    endSet=true
    on(events(scene).mousedrag) do buttons
        if ispressed(scene, Mouse.left)
            pos = to_world(scene, Point2(scene.events.mouseposition[]))
            position = (round(Int,(pos[1]/axes(img)[2][end])*axes(img)[1][end]),round(Int,(pos[2]/axes(img)[1][end])*axes(img)[2][end]))
            if minimum(position)>1 && position[1]<axes(img)[1][end]-1 && position[2]<axes(img)[2][end]-1
                push!(clicks, push!(clicks[], pos))
                labels[position[1],position[2]]=region
                if suppress_feedback == false
                    @show position, region
                end
            end
        end
        return
    end
    on(scene.events.keyboardbuttons) do buttons
        if ispressed(scene, Keyboard.up)
            region += 1
            if suppress_feedback == false
                @show region
            end
        end
        if ispressed(scene, Keyboard.down)
            if region!=1
                region -= 1
                if suppress_feedback == false
                    @show region
                end
            end
        end
        return
    end
    scatter!(scene, clicks, color = :red, marker = '.', markersize = 3,show_axis = false)
end

function set_seed_pixels3(labels::Array{Int,3}, img::AbstractArray,layer::Int = 1; suppress_feedback::Bool=false)
    @show "hi"
    scene = Scene()
    clicks = Node(Point2f0[])
    region = 1
    #layer  = 1
    endSet = true
    image!(scene,img[:,:,layer], show_axis = false)
    on(events(scene).mousedrag) do buttons
        if ispressed(scene, Mouse.left)
            pos = to_world(scene, Point2(scene.events.mouseposition[]))
            position = (round(Int,(pos[1]/axes(img)[2][end])*axes(img)[1][end]),round(Int,(pos[2]/axes(img)[1][end])*axes(img)[2][end]))
            if minimum(position)>1 && position[1]<axes(img)[1][end]-1 && position[2]<axes(img)[2][end]-1
                push!(clicks, push!(clicks[], pos))
                labels[position[1],position[2],layer]=region
                if suppress_feedback == false
                    @show position, layer, region
                end
            end
        end
        return
    end
    on(scene.events.keyboardbuttons) do buttons
        if ispressed(scene, Keyboard.up)
            region += 1
            if suppress_feedback == false
                @show region
            end
        end
        if ispressed(scene, Keyboard.down)
            if region!=1
                region -= 1
                if suppress_feedback == false
                    @show region
                end
            end
        end
        if ispressed(scene, Keyboard.right)
            layer += 1
            set_seed_pixels3(labels,img,layer)
            #change(layer,img)
            if suppress_feedback == false
                @show layer
            end
        end
        if ispressed(scene, Keyboard.enter)
            endSet=false
        end
        return
    end
    scatter!(scene, clicks, color = :red, marker = '.', markersize = 3,show_axis = false)
end

function change(layer,img)
    image!(img[:,:,layer], show_axis = false)
end
