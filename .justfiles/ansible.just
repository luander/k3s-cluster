venv:
    python3 -m venv .venv \
    && . .venv/bin/activate \
    && pip install -r ansible/requirements.txt
    .venv/bin/ansible-galaxy role install -vr ansible/meta/requirements.yaml

apply: venv
    .venv/bin/ansible-playbook -i ansible/inventory.yaml ansible/k3s-install.yaml

check: venv
    .venv/bin/ansible-playbook -i ansible/inventory.yaml \
        --check \
        --diff \
        ansible/k3s-install.yaml

restart: venv
    .venv/bin/ansible-playbook -i ansible/inventory.yaml \
        -e 'k3s_state=restarted' \
        ansible/k3s-install.yaml

remove: venv
    .venv/bin/ansible-playbook -i ansible/inventory.yaml \
        ansible/k3s-remove.yaml

ping: venv
    .venv/bin/ansible -i ansible/inventory.yaml -m ping all
