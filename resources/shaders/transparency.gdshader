shader_type canvas_item;

uniform sampler2D texture; // The main texture
uniform float alpha : hint_range(0.0, 1.0); // Transparency control from 0.0 (fully transparent) to 1.0 (fully opaque)

void fragment() {
    vec4 tex_color = texture(texture, UV); // Sample the texture color
    tex_color.a *= alpha; // Apply the uniform alpha value to the texture's alpha
    COLOR = tex_color; // Set the fragment color
}
