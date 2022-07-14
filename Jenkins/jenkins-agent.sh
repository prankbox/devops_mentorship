docker run -d --rm --name=agent1 -p 22:22 \
--network jenkins \
-e "JENKINS_AGENT_SSH_PUBKEY=ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHKkhVhCir3KaqaNcJIU3qFasW7R+i5xyIXry0O4Jx/uQ+9AZZp8QtdxX9dek/8N/oUCaP4ektWHL3wZ31f1b81aNLeOiDVOFjZG/fzVBGfY/ivGVZjDo3RuG3MIKqhBBMn2eyJ/9v1L84ZmWb6ApQFTqOXATkmS15XDmzMqeBitU7p7ex3H5GucB6fN7o6qn0iiD8pza4oSQT4v57s/3PJxCmcb7Kx3jMGUUp8ifjTJeuOVBOx2HlUVmUhsVA+6o/skT5tuWMAeBUExxS+SnkpilPcgStYh6rmT931cgDu2jBdFLuYD5/CxPlvS+owtmFj8i61iwoWokf0eKfVpnqlIPMiJytRt4AzUT2HKhL1VRghEiTAJwc5CJ+UOhrN01maaIQdJLfzXD5DFYDVeOEPiIVSWwDnrfKHysE1Zhv+KBlE9x/bChDr6QflHUgx7ijcLO885kBLU15Zmw3RjNnhOElukCgg6C28AJRuHQKrJcSkczaEAHfWRORZk7lM9U= sergey@MacBook-Pro-Sergey.local" \
-e DOCKER_HOST=tcp://docker:2376 \
-e DOCKER_CERT_PATH=/certs/client \
-e DOCKER_TLS_VERIFY=1 \
--volume jenkins-data:/var/jenkins_home \
--volume jenkins-docker-certs:/certs/client:ro \
jenkins-agent:0.3


docker run -d --rm --name=agent2 -p 2222:22 \
-e "JENKINS_AGENT_SSH_PUBKEY=ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHKkhVhCir3KaqaNcJIU3qFasW7R+i5xyIXry0O4Jx/uQ+9AZZp8QtdxX9dek/8N/oUCaP4ektWHL3wZ31f1b81aNLeOiDVOFjZG/fzVBGfY/ivGVZjDo3RuG3MIKqhBBMn2eyJ/9v1L84ZmWb6ApQFTqOXATkmS15XDmzMqeBitU7p7ex3H5GucB6fN7o6qn0iiD8pza4oSQT4v57s/3PJxCmcb7Kx3jMGUUp8ifjTJeuOVBOx2HlUVmUhsVA+6o/skT5tuWMAeBUExxS+SnkpilPcgStYh6rmT931cgDu2jBdFLuYD5/CxPlvS+owtmFj8i61iwoWokf0eKfVpnqlIPMiJytRt4AzUT2HKhL1VRghEiTAJwc5CJ+UOhrN01maaIQdJLfzXD5DFYDVeOEPiIVSWwDnrfKHysE1Zhv+KBlE9x/bChDr6QflHUgx7ijcLO885kBLU15Zmw3RjNnhOElukCgg6C28AJRuHQKrJcSkczaEAHfWRORZk7lM9U= sergey@MacBook-Pro-Sergey.local" \
--network jenkins \
jenkins/ssh-agent:latest-alpine-jdk8

{
VARS1="HOME=|USER=|MAIL=|LC_ALL=|LS_COLORS=|LANG="
VARS2="HOSTNAME=|PWD=|TERM=|SHLVL=|LANGUAGE=|_="
VARS="${VARS1}|${VARS2}"
docker exec agent2 sh -c "env | egrep -v '^(${VARS})' >> /etc/environment"
}