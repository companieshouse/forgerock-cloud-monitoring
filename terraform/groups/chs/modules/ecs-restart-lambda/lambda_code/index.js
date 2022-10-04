const AWS = require('aws-sdk');

exports.main = async function(event, context) {
    const ecs = new AWS.ECS();
    ecs.updateService({
        cluster: process.env.ecs_cluster_arn,
        service: process.env.ecs_cluster_name,
        forceNewDeployment: true
    }).catch(error => {
            throw error;
        });
}