ansible-playbook automation/remove_cluster.yml --extra-vars \
  "ansible_user=rocky \
   cloud_provider='aws' \
   cloud_load_balancer=false \
   server_count=3 \
   server_type='t3.small' \
   server_image='ami-089c9ff9950d7c00d' \
   server_location='us-east-2' \
   aws_s3_bucket_name='autobase-cluster-backup' \
   aws_s3_bucket_region='us-east-2' \
   pgbackrest_install=true \
   volume_size=100 \
   postgresql_version=17 \
   patroni_cluster_name='postgres-cluster-01' \
   ssh_key_name='autobase'"
