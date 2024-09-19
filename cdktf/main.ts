import { App } from "cdktf";

import { IonosCloudStack } from "./stacks/ionoscloud-stack";
import { RouterOSStack } from "./stacks/routeros-stack";
import { KubernetesStack } from "./stacks/kubernetes-stack";

import { config } from 'dotenv';

config();
const app = new App();

new IonosCloudStack(app, "ionoscloud");
new RouterOSStack(app, "routeros");
new KubernetesStack(app, "kubernetes");

app.synth();
