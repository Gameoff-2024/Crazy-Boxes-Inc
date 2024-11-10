extends Object

class_name MathUtils

static func calc_plane_normal(segment_start: Vector3, segment_end: Vector3, plane_direction: Vector3) -> Vector3:
	# 1. Get the direction vector of the segment
	var segment_direction = (segment_end - segment_start).normalized()

	# 2. Calculate the normal of the plane using the cross product
	var plane_normal = segment_direction.cross(plane_direction).normalized()

	return plane_normal
	
static func calculate_tangent_angle(segment_start: Vector3, segment_end: Vector3, plane_normal: Vector3) -> float:
	# 1. Get the direction vector of the segment
	var segment_direction = (segment_end - segment_start).normalized()

	# 2. Calculate the dot product between the segment direction and the plane normal
	var dot_product = segment_direction.dot(plane_normal)

	# 3. Use acos to find the angle between the direction and the normal
	var angle_radians = acos(dot_product)

	# 4. The tangent angle is the complementary angle to the angle with the normal
	var tangent_angle_radians = PI / 2 - angle_radians  # Convert to tangent angle

	# Optional: Convert to degrees if needed
	var tangent_angle_degrees = rad_to_deg(tangent_angle_radians)

	return tangent_angle_degrees  # or return tangent_angle_radians if you need it in radians
	
static func calc_tangent_vector(segment_start: Vector3, segment_end: Vector3, plane_normal: Vector3) -> Vector3:
	# 1. Get the direction vector of the segment
	var segment_direction = (segment_end - segment_start).normalized()

	# 2. Project the segment direction onto the plane to get the tangent vector
	# Calculate the component of segment_direction along the plane_normal
	var projection_on_normal = plane_normal * segment_direction.dot(plane_normal)

	# Subtract this component from the segment direction to get the tangent vector
	var tangent_vector = (segment_direction - projection_on_normal).normalized()

	return tangent_vector
