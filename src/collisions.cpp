#include "collisions.h"

bool ColisaoPontoPlano(float yp, float yc){
    float altura = 6;
    bool colisao = false;

    if(yp == altura + yc){
        colisao = true;
    }
    return colisao;
}

bool ColisaoEsferaEsfera(struct sphere_t* sphere1, struct sphere_t* sphere2) {

    float r_sum = sphere1->radius + sphere2->radius;
    float distance_squared = pow(sphere1->position.x - sphere2->position.x, 2) +
                              pow(sphere1->position.y - sphere2->position.y, 2) +
                              pow(sphere1->position.z - sphere2->position.z, 2);
    return distance_squared <= r_sum * r_sum;
}

bool ColisaoCuboEsfera(struct  cubo_t* cubo, struct sphere_t* sphere) {

    float deltaX = std::abs(cubo->position.x - cubo->position.x);
    float deltaY = std::abs(cubo->position.y - sphere->position.y);
    float deltaZ = std::abs(cubo->position.z - sphere->position.z);

    float projectionX = deltaX - cubo->width / 2.0f;
    float projectionY = deltaY - cubo->height / 2.0f;
    float projectionZ = deltaZ - cubo->depth / 2.0f;

    // Verificar se a esfera está dentro do cubo em cada eixo
    if (projectionX < 0)
        projectionX = 0;
    if (projectionY < 0)
        projectionY = 0;
    if (projectionZ < 0)
        projectionZ = 0;

    float distanciaQuadrada = projectionX * projectionX + projectionY * projectionY + projectionZ * projectionZ;

    return distanciaQuadrada <= (sphere->radius * sphere->radius);
}
