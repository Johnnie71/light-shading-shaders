uniform vec3 uColor;
varying vec3 vNormal;
varying vec3 vPosition;

#include ../includes/ambientLight.glsl;

vec3 directionalLight(vec3 lightColor, float lightIntensity, vec3 normal, vec3 lightPosition, vec3 viewDirection, float specularPower) {
    vec3 lightDirection = normalize(lightPosition);
    vec3 lightReflection = reflect(- lightDirection, normal);

    // Shading
    float shading = dot(normal, lightDirection);
    shading = max(0.0, shading);

    // Specular
    float specular = - dot(lightReflection, viewDirection);
    specular = max(0.0, specular);
    specular = pow(specular, specularPower);

    return lightColor * lightIntensity * (shading + specular);
}

void main()
{
    vec3 normal = normalize(vNormal);
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 color = uColor;

    // lights
    vec3 light = vec3(0.0);
    light += ambientLight(
        vec3(1.0), // light color
        0.03 // light intensity
    );
    light += directionalLight(
        vec3(0.1, 0.1, 1.0),
        1.0,
        normal,
        vec3(0.0, 0.0, 3.0),
        viewDirection,
        20.0
    );
    color *= light;
 
    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}