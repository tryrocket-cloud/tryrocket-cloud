import { Construct } from "constructs";
import { TerraformStack } from "cdktf";
// import { KubernetesProvider } from "@cdktf/provider-kubernetes/lib/provider";

export class KubernetesStack extends TerraformStack {
    constructor(scope: Construct, id: string) {
        super(scope, id);

        // // Define the Kubernetes provider (replace with actual cluster details)
        // new KubernetesProvider(this, "k8s", {
        //     configPath: "~/.kube/config" // Adjust this to point to your kubeconfig
        // });

        // // Execute kubectl apply -k <github.com>
        // new LocalExec(this, "apply-kustomize", {
        //     command: "kubectl apply -k https://github.com/some/repo/kustomization"
        // });
    }
}
