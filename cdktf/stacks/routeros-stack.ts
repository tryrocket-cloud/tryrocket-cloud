import { Construct } from "constructs";
import { TerraformStack } from "cdktf";

export class RouterOSStack extends TerraformStack {
    constructor(scope: Construct, id: string) {
        super(scope, id);

        this.addOverride('terraform.required_providers', {
            routeros: {
                source: "terraform-routeros/routeros",
                version: "~> 1.61.2"
            }
        });

        // Define the provider manually using addOverride
        this.addOverride('provider.routeros', {
            hosturl: process.env.ROUTEROS_ADDRESS!,
            username: process.env.ROUTEROS_USERNAME!,
            password: process.env.ROUTEROS_PASSWORD!,
            insecure: true
        });

        // const dnsEntries = [
        //     { domain: 'optiplex-3080.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'thinkcentre-m700.tryrocket.cloud', address: '192.168.178.102' },
        //     { domain: 'longhorn.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'argocd.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'homer.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'pgadmin4.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'immich.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'memos.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'linkding.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'invidious.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'vaultwarden.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'adguard-home.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'opengist.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'gitea.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'matrix.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'traefik.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'cinny.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'vault.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'semaphore.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'davis.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'faq.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'upsnap.tryrocket.cloud', address: '192.168.178.101' },
        //     { domain: 'h610i.tryrocket.cloud', address: '192.168.178.120' },
        // ];

        this.addOverride('resource.routeros_ip_dns_record.dns_entry', {
            name: "abc.tryrocket.cloud",
            address: "192.168.178.101",
            type: "A"
        });
    }
}
