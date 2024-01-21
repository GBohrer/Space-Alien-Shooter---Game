#version 330 core

// Atributos de vértice recebidos como entrada ("in") pelo Vertex Shader.
// Veja a função BuildTrianglesAndAddToVirtualScene() em "main.cpp".
layout (location = 0) in vec4 model_coefficients;
layout (location = 1) in vec4 normal_coefficients;
layout (location = 2) in vec2 texture_coefficients;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Atributos de vértice que serão gerados como saída ("out") pelo Vertex Shader.
// ** Estes serão interpolados pelo rasterizador! ** gerando, assim, valores
// para cada fragmento, os quais serão recebidos como entrada pelo Fragment
// Shader. Veja o arquivo "shader_fragment.glsl".
out vec4 position_world;
out vec4 position_model;
out vec4 normal;
out vec2 texcoords;

uniform sampler2D TextureImage3;

#define GUN    3
#define ALIEN  4
uniform int object_id;

//uniform vec4 light_position; // sequiser ponto de luz
out vec4 cor_v;

void main()
{
    // A variável gl_Position define a posição final de cada vértice
    // OBRIGATORIAMENTE em "normalized device coordinates" (NDC), onde cada
    // coeficiente estará entre -1 e 1 após divisão por w.
    // Veja {+NDC2+}.
    //
    // O código em "main.cpp" define os vértices dos modelos em coordenadas
    // locais de cada modelo (array model_coefficients). Abaixo, utilizamos
    // operações de modelagem, definição da câmera, e projeção, para computar
    // as coordenadas finais em NDC (variável gl_Position). Após a execução
    // deste Vertex Shader, a placa de vídeo (GPU) fará a divisão por W. Veja
    // slides 41-67 e 69-86 do documento Aula_09_Projecoes.pdf.

    gl_Position = projection * view * model * model_coefficients;

    // Como as variáveis acima  (tipo vec4) são vetores com 4 coeficientes,
    // também é possível acessar e modificar cada coeficiente de maneira
    // independente. Esses são indexados pelos nomes x, y, z, e w (nessa
    // ordem, isto é, 'x' é o primeiro coeficiente, 'y' é o segundo, ...):
    //
    //     gl_Position.x = model_coefficients.x;
    //     gl_Position.y = model_coefficients.y;
    //     gl_Position.z = model_coefficients.z;
    //     gl_Position.w = model_coefficients.w;
    //

    // Agora definimos outros atributos dos vértices que serão interpolados pelo
    // rasterizador para gerar atributos únicos para cada fragmento gerado.

    // Posição do vértice atual no sistema de coordenadas global (World).
    position_world = model * model_coefficients;

    // Posição do vértice atual no sistema de coordenadas local do modelo.
    position_model = model_coefficients;

    // Normal do vértice atual no sistema de coordenadas global (World).
    // Veja slides 123-151 do documento Aula_07_Transformacoes_Geometricas_3D.pdf.
    normal = inverse(transpose(model)) * normal_coefficients;
    normal.w = 0.0;

    if ( object_id == GUN || object_id == ALIEN)
    {
        //Iluminação Gourand ------------modelo desejado??-------------------------
        // Normal do fragmento atual, interpolada pelo rasterizador a partir das
        // normais de cada vértice.
        vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
        vec4 camera_position = inverse(view) * origin;
        vec4 p = position_world;

        vec4 n = normalize(normal);
        // Vetor que define o sentido da fonte de luz em relação ao ponto atual.
        vec4 l = normalize(vec4(-5.0,2.0,0.0,0.0)); //fonte de luz?
        float lambert = max(0,dot(n,l));
        // Vetor que define o sentido da câmera em relação ao ponto atual.
        vec4 v = normalize(camera_position - p);
        // Vetor que define o sentido da reflexão especular ideal.
        vec4 r = -l + 2*n*(dot(n,l));

        // Coordenadas de textura U e V
        float U = 0.0;
        float V = 0.0;

        // Coordenadas de textura obtidas do arquivo OBJ
        texcoords = texture_coefficients;

        // Coordenadas de textura do plano, obtidas do arquivo OBJ.
        U = texcoords.x;
        V = texcoords.y;

        vec3 Kd3 = texture(TextureImage3, vec2(U,V)).rgb; //gun
        vec3 Ks = vec3(0.3f, 0.3f, 0.3f);
        vec3 Ka = vec3(0.0,0.0,0.0);
        vec3 I = vec3(1.0f,1.0f,1.0f); //espectro da fonte de luz
        vec3 Ia = vec3(0.2f, 0.2f, 0.2f);// Espectro da luz ambiente

        vec3 lambert_diffuse_term = Kd3 * I * max(0,dot(n,l));
        vec3 ambient_term = Ka * Ia;
        vec3 phong_specular_term  = Ks * I * max(0,dot(r,v));

        cor_v.rgb = (ambient_term + lambert_diffuse_term + phong_specular_term );

        cor_v.a = 1;

        // Cor final com correção gamma, considerando monitor sRGB.
        // Veja https://en.wikipedia.org/w/index.php?title=Gamma_correction&oldid=751281772#Windows.2C_Mac.2C_sRGB_and_TV.2Fvideo_standard_gammas
        cor_v.rgb = pow(cor_v.rgb, vec3(1.0,1.0,1.0)/2.2);

    }
    //--------------------------------------------------------

    // Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
    texcoords = texture_coefficients;
}

