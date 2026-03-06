float opUnion( float a, float b )
{
    return min(a,b);
}
float opSubtraction( float a, float b )
{
    return max(-a,b);
}
float opIntersection( float a, float b )
{
    return max(a,b);
}

float opSmoothUnion( float a, float b, float k )
{
    k *= 4.0;
    float h = max(k-abs(a-b),0.0);
    return min(a, b) - h*h*0.25/k;
}

float opSmoothSubtraction( float a, float b, float k )
{
    return -opSmoothUnion(a,-b,k);
}

float opSmoothIntersection( float a, float b, float k )
{
    return -opSmoothUnion(-a,-b,k);
}

float opOnion( in float sdf, in float thickness )
{
    return abs(sdf)-thickness;
}