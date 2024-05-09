import * as THREE from 'https://cdn.skypack.dev/three@v0.133.1';
import {OrbitControls} from 'https://cdn.skypack.dev/three@v0.133.1/examples/jsm/controls/OrbitControls.js';
//import { OrbitControls } from 'https://cdn.skypack.dev/three@v0.133.1/ examples/jsm/controls/OrbitControls.js';
import threejsOrbitControls from 'https://cdn.skypack.dev/threejs-orbit-controls';
import {PointerLockControls} from 'https://cdn.skypack.dev/three@v0.133.1/examples/jsm/controls/PointerLockControls.js';
import {STLLoader} from 'https://cdn.skypack.dev/three@v0.133.1/examples/jsm/loaders/STLLoader.js';


export function render3dScene(stlFile, containerEl) {

    console.log(containerEl)
// The three.js scene: the 3D world where you put objects
    const scene = new THREE.Scene();

    let stlElement = new THREE.Group()
    scene.add(stlElement)

    const loader = new STLLoader()
    loader.load(stlFile, function (geometry) {
        console.log('geometry=', geometry)

        const pbr_material = new THREE.MeshPhysicalMaterial({
            color: '#aaaaaa',
            metalness: 0,
            roughness: 0.5,
            clearcoat: 1.0 - params.alpha,
            clearcoatRoughness: 1.0 - params.beta,
            reflectivity: 1.0 - params.gamma,
            envMap: null
        })

        const material =
            new THREE.MeshPhongMaterial({color: '#aaaaaa', specular: 0x111111, shininess: 0})
        let mesh = new THREE.Mesh(geometry, pbr_material)
        mesh.position.set(0, 0, 0)
        mesh.scale.set(0.05, 0.05, 0.05)
        // mesh.castShadow = true
        // mesh.receiveShadow = true

        geometry.center()
        // mesh.rotation.z += Math.PI;
        stlElement.add(mesh)
    })

    var params = {
        wireframe: false,
        alpha: 0.5,
        beta: 0.5,
        gamma: 0.5
    };

    function initializeCamera() {
        const camera = new THREE.PerspectiveCamera(
            60, // field of view
            containerEl.clientWidth / containerEl.clientHeight, // aspect ratio
            0.5, // near clip
            10000 // far clip
        );
        camera.position.z = 3;
        camera.position.y = 3;
        const orbit = new OrbitControls(camera, renderer.domElement);
        orbit.update(); // call when camera position gets changed
        const controls = new PointerLockControls(camera, renderer.domElement);
        const onKeyDown = function (KeyboardEvent) {
            switch (event.code) {
                case 'KeyW':
                    controls.moveForward(0.25)
                    break;
                case 'KeyS':
                    controls.moveForward(-0.25);
                    break;
                case 'KeyD':
                    controls.moveRight(0.25);
                    break;
                case 'KeyA':
                    controls.moveRight(-0.25);
                    break;
            }
        }
        document.addEventListener('keydown', onKeyDown, false)
        return camera;
    }

    function initializeLight() {
        let ambientLight = new THREE.AmbientLight('#ffffff', 0.1)
        ambientLight.position.set(1, 1, 1)
        scene.add(ambientLight)

        let hemisphereLight = new THREE.HemisphereLight(0xB1E1FF, 0xB97A20, 0.5)
        hemisphereLight.position.set(0, 0, 20)
        scene.add(hemisphereLight)

        let directionalLight = new THREE.DirectionalLight('#ffffff', 0.5)
        directionalLight.position.set(8, 2, 10)
        scene.add(directionalLight)
    }

    const renderer = new THREE.WebGLRenderer({antialias: true});
    renderer.setSize(containerEl.clientWidth, containerEl.clientHeight); // TODO
    renderer.setClearColor(0xaaaaaa, 1);
    containerEl.appendChild(renderer.domElement);

    let camera = initializeCamera()
    initializeLight()


    const totalDuration = 8;
    const amountUpdates = 8 * 60;
    const delta = Math.PI*2/amountUpdates;


    setInterval(() => {
        const time = Date.now()
        const relTime = time % (1000 * totalDuration);
        const percentageFinished = relTime / (1000 * totalDuration);
        const rotation = percentageFinished * Math.PI * 2;

        stlElement.children[0].rotation.y = rotation;
        // stlElement.children[0].rotation.z += delta;
    }, 1000/60)


    function render() {
        // Render the scene and the camera
        renderer.render(scene, camera);

        //camera.position.set(params.CamX, params.CamY, params.CamZ)
        //console.log(direction)
        //camera.rotation.set(direction.x, direction.y, direction.z)
        //camera.rotation.set(camera.position.sub(cube.mesh.position))

        // Rotate the cube every frame

        // let bool = true;
        // if(bool){
        //     bool = false;
        //     console.log('stlElement=', stlElement)
        // }



        if (stlElement.children[0]) {
            // stlElement.children[0].rotation.z += Math.PI;
            // stlElement.children[0].rotation.x += 0.01;
        }
        // Make it call the render() function about every 1/60 second
        requestAnimationFrame(render);
    }

    render();
}

