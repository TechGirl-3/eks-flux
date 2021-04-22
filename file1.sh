cmd=`kubectl get daemonsets --all-namespaces | grep -E 'aws-node|kube-proxy'`
echo $cmd
#if $cmd
if [ $? -eq 0 ];
then
    echo "present"
    kubectl delete daemonset -n kubes-proxy aws-node
else
    echo "no present"
fi
