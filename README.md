# Lava Procedular for Construct 3

<img width="400" height="270" alt="main_image" src="https://github.com/user-attachments/assets/42ec8695-a5e3-4406-b0be-aea67fa4d3f8" />

This repository contains code for the [Lava Procedular Construct effect](https://www.construct.net/make-games/addons/1543/lava-procedural-effect). A customizable procedural fluid-motion shader. It generates dynamic swirling lava by default, but its parameters allow you to create your own unique styles, it also works great for simulating drifting smoke, and other organic effects. Configurable noise, speed, flow direction, scale, color, contrast and more options give you creative control. There are two main components in this repository:

- *construct-addon*: the Construct addon, written in GLSL/WGSL using the [Construct Addon SDK](https://github.com/Scirra/Construct-Addon-SDK)
- *example-project*: the Construct example project, demonstrating some of the effect capabilities

## Distributing

The Construct plugin is distributed as a [.c3addon file](https://www.construct.net/en/make-games/manuals/addon-sdk/guide/c3addon-file), which is essentially a renamed zip file with the addon files.

> [!WARNING]
> If you want to modify the plugin for your own purposes, it is strongly advised to **change the Construct plugin ID.** This will avoid serious compatibility problems which could result in your project becoming unopenable.

## Download & Install Instructions

Download the latest [release](https://github.com/Everade/LavaProcedular/releases). To install an addon in Construct 3, open the Addon Manager (Menu > View > Addon Manager). In this dialog, click "Install new addon..." and choose the .c3addon file. Construct 3 will prompt to confirm installation of the addon. If you confirm the install, you must restart Construct 3 before the addon is available. In the browser you can just press the Reload button. You can also install itby directly dragging and dropping the .c3addon file in to Construct 3.

## Examples

<img width="400" height="400" alt="image01" src="https://github.com/user-attachments/assets/2effe804-caa3-4d00-88ca-2f51818048b7" /><img width="400" height="400" alt="image02" src="https://github.com/user-attachments/assets/593d52c1-dd5b-4f7b-8383-322d2d07ad31" />
<img width="400" height="400" alt="image03" src="https://github.com/user-attachments/assets/1221a3b9-4d3d-436a-9bc3-8093fc01e811" /><img width="400" height="400" alt="image04" src="https://github.com/user-attachments/assets/49aa9b94-3c92-4cae-9e6b-949f78f1355b" />
<img width="400" height="400" alt="image05" src="https://github.com/user-attachments/assets/496a82ef-7657-4f07-bd79-2237ce2bccfc" /><img width="400" height="400" alt="image06" src="https://github.com/user-attachments/assets/bad9a1a0-4d21-4b4b-9152-c8fdbdd331e1" />

https://github.com/user-attachments/assets/429982bd-b7b5-4cea-ae9b-5fae8a01b7be

## Features

- Supports WebGL1, WebGL2 and WebGPU.
- Settings for noise, speed, flow direction, scale, color, contrast, time offset

## Attribution

Based on a shader by stormoid. [X](https://x.com/stormoid), [ShaderToy](https://www.shadertoy.com/view/lslXRS)

Release of this derivative work under the MIT License was explicitly granted by stormoid.

## License

This code is published under the [MIT license](LICENSE).
