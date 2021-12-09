set -x -e

INSTANCE="erecrutement-cvd-staging"
OLD_BUCKET="cvd-staging"

# Copy old OSU data to new OSS
rclone copyto -P osu-$INSTANCE:$OLD_BUCKET oos-$INSTANCE:$INSTANCE --checkers 16 --transfers 16

# Fix ACL on new OSS
FOLDERS="operator_logos partner_1_logos partner_2_logos partner_3_logos logo_horizontals testimony_logos image_backgrounds"
for FOLDER in $FOLDERS; do
  aws s3 cp --recursive --acl public-read s3://$INSTANCE/organizations/$FOLDER s3://$INSTANCE/organizations/$FOLDER --metadata-directive REPLACE --endpoint https://oos.cloudgouv-eu-west-1.outscale.com --profile oos-$INSTANCE --page-size=100000 --cli-read-timeout 0
done
