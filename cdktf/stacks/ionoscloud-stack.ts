import { Construct } from "constructs";
import { TerraformStack } from "cdktf";
import { IonoscloudProvider } from "@cdktf/provider-ionoscloud/lib/provider";
import { S3Bucket } from "@cdktf/provider-ionoscloud/lib/s3-bucket";
import { User } from "@cdktf/provider-ionoscloud/lib/user";
import { Group } from "@cdktf/provider-ionoscloud/lib/group";
import { RandomProvider } from "@cdktf/provider-random/lib/provider";
import { Password } from "@cdktf/provider-random/lib/password";
import { S3Key } from "@cdktf/provider-ionoscloud/lib/s3-key";
// import { S3BucketPolicy } from "@cdktf/provider-ionoscloud/lib/s3-bucket-policy";
import { KvSecretV2 } from "@cdktf/provider-vault/lib/kv-secret-v2";
import { VaultProvider } from "@cdktf/provider-vault/lib/provider"; // Import VaultProvider

export class IonosCloudStack extends TerraformStack {
    constructor(scope: Construct, id: string) {
        super(scope, id);

        new IonoscloudProvider(this, 'ionoscloud', {
            token: process.env.IONOS_TOKEN!,
            s3AccessKey: process.env.IONOS_S3_ACCESS_KEY!,
            s3SecretKey: process.env.IONOS_S3_SECRET_KEY!
        });

        new RandomProvider(this, 'random');

        new VaultProvider(this, "vault-provider", {
            address: process.env.VAULT_ADDR!,
            token: process.env.VAULT_TOKEN!,
        });

        const users = [
            { firstName: 'Vaultwarden', lastName: 'Kopia', email: 'vaultwarden.kopia@tryrocket.cloud', prefix: 'backup/vaultwarden/kopia' },
            { firstName: 'Vaultwarden', lastName: 'Restic', email: 'vaultwarden.restic@tryrocket.cloud', prefix: 'backup/vaultwarden/restic' },
            { firstName: 'Vault', lastName: 'Kopia', email: 'vault.kopia@tryrocket.cloud', prefix: 'backup/vault/kopia' },
            { firstName: 'Vault', lastName: 'Restic', email: 'vault.restic@tryrocket.cloud', prefix: 'backup/vault/restic' },
            { firstName: 'Davis', lastName: 'Kopia', email: 'davis.kopia@tryrocket.cloud', prefix: 'backup/davis/kopia' },
            { firstName: 'Davis', lastName: 'Restic', email: 'davis.restic@tryrocket.cloud', prefix: 'backup/davis/restic' }
        ];

        new S3Bucket(this, 'my-s3-bucket', { name: "rocket-cloud-bucket" });

        const group = new Group(this, 'backup-group', { name: "backup", s3Privilege: true });

        // Loop over the users and create a user and S3 key for each one
        users.forEach((user, index) => {

            const userPassword = new Password(this, `password-${index}`, {
                length: 128,
                special: false
            });

            const createdUser = new User(this, `user-${index}`, {
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email,
                password: userPassword.result,
                groupIds: [group.id],
                active: true
            });

            // Create an S3 access key for the user
            const s3Key = new S3Key(this, `s3key-${index}`, {
                userId: createdUser.id,
                active: true
            });

            // Store user credentials in Vault
            new KvSecretV2(this, `vault-user-${index}`, {
                mount: "kv",
                name: `ionos.com/users/${user.email}`,
                dataJson: JSON.stringify({
                    id: createdUser.id,
                    email: createdUser.email,
                    password: userPassword.result,
                    s3AccessKey: s3Key.secretKey
                })
            });

            // TODO: add policy to the bucket
            // // Loop over the prefixes and create a policy for each user-prefix combination
            // prefixes.forEach((prefixConfig) => {
            //     const bucketPolicy = new S3BucketPolicy(this, `policy-${index}-${prefixConfig}`, {
            //         bucket: s3Bucket.name,
            //         policy: JSON.stringify({
            //             Version: "2012-10-17",
            //             Statement: [
            //                 {
            //                     Sid: `AllowUser${index}AccessToPrefix${prefixConfig}`,
            //                     Effect: "Allow",
            //                     Principal: { AWS: [`arn:aws:iam:::user/${createdUser.id}`] },
            //                     Action: [
            //                         "s3:GetObject",
            //                         "s3:PutObject",
            //                         "s3:DeleteObject"
            //                     ],
            //                     Resource: [
            //                         `${s3Bucket}/${prefixConfig}/*`
            //                     ]
            //                 }
            //             ]
            //         })
            //     });
            // });
        });
    }
}
