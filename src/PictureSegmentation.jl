module PictureSegmentation

using Images
using Makie
using ColorVectorSpace

abstract type SegmentationAlgorithm end
struct GrowCut <: SegmentationAlgorithm end
struct GrowCut3 <: SegmentationAlgorithm end

include("common.jl")
include("seedpixel.jl")
include("growcut.jl")
include("growcut3d.jl")

export
	# main functions
	segment_image,
	set_seed_pixels,
	GrowCut,
	display_3d
end # module
