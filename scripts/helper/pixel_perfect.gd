class_name PixelPerfect
extends Node
## This class turns [Vector2]s into pixel-perfect co-ordinates

## The size of each pixel
const pixel_size: int = 1

## Converts the specified [Vector2] into a pixel-perfect [Vector2] with the size of [member PixelPerfect.pixel_size]
static func to_pixel_perfect(coords: Vector2) -> Vector2:
	return to_pixel_perfect_custom_size(coords, pixel_size)


## Converts the specified [Vector2] into a pixel-perfect [Vector2] with the size of [param size]
static func to_pixel_perfect_custom_size(coords: Vector2, size: int) -> Vector2:
	return (coords / size).round() * size
