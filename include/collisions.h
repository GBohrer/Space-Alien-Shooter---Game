// Headers da biblioteca GLM: criação de matrizes e vetores.
#include <glm/mat4x4.hpp>
#include <glm/vec4.hpp>
#include <glm/gtc/type_ptr.hpp>

// Struct para hitbox esférica
struct sphere_t{

    glm::vec3 position;
    int radius;

};

struct cubo_t{

    glm::vec3 position;
    float width;
    float height;
    float depth;

};

bool ColisaoPontoPlano(float yp, float yc);
bool ColisaoEsferaEsfera(struct sphere_t *sphere1, struct sphere_t *sphere2);
bool ColisaoCuboEsfera(struct  cubo_t* cubo, struct sphere_t* esfera);
