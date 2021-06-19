shader_type canvas_item;
uniform highp vec2 position = vec2(0.0, 0.0);
uniform float num_iterations = 20.;
uniform float scale = 3.0;
uniform float ar = 1.7777777;
uniform bool julia = true;

// x, y lie in [0, 1]
// cx, cy lie in [0, 1]
float get_iterations(float x, float y, float cx, float cy, float max_iterations)
{
	// make coordinates lie in [-scale, scale]
	highp vec2 c, z;
	z.x = ar * scale * (x -  0.5);
	z.y = scale * (y - 0.5);
	c.x = ar * scale * (cx -  0.5);
	c.y = scale * (cy - 0.5);

	float iter = 0.;
	while(iter < max_iterations && length(z) <= 2.0)
	{
		z = vec2(z.x * z.x - z.y * z.y, 2. * z.x * z.y) + c;
		iter++;
	}
	return iter;
}

vec4 get_color(float iter_frac)
{
	// 0.0 -> black (0, 0, 0)
	// p1 -> blue (0, 0, 1)
	// p2 -> white (1, 1, 1)
	// 1.0 -> orange (1, 0.5, 0)
	float p1 = 1./6.;
	float p2 = 5./6.;
	if (iter_frac < p1)
	{
		float f = iter_frac/p1;
		return vec4(0, 0, f, 1.);
	}
	else if (iter_frac < p2)
	{
		float f = (iter_frac - p1) / (p2 - p1);
		float r = f;
		float g = f;
		float b = 1.;
		return vec4(r, g, b, 1.);
	}
	else
	{
		float f = (iter_frac - p2) / (1. - p2);
		float r = 1.;
		float g = (1. - f) + f * 0.5 ;
		float b = 1. - f;
		return vec4(r, g, b, 1.);
	}
}

// iter_frac lies in in [0, 1]
vec4 color_madelbrot(float x, float y)
{
	float iter_frac = 1. - get_iterations(x, y, x, y, num_iterations) / num_iterations;
	return get_color(iter_frac);
}

vec4 color_julia(float x, float y)
{
	float iter_frac = 1. - get_iterations(x, y, position.x, position.y, num_iterations) / num_iterations;
	return get_color(iter_frac);
}

void fragment() 
{
	// UV layout
	// (0, 0) ----- (1, 0)
	// |               |
	// |               |
	// |               |
	// (0, 1) ----- (1, 1)
	if (julia)
	{
		COLOR = color_julia(UV.x, UV.y);	
	}
	else
	{
		COLOR = color_madelbrot(UV.x, UV.y);	
	}	
}