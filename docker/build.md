```shell
# Enable buildx
docker buildx create --name multi-platform --use --platform linux/amd64,linux/arm64 --driver docker-container --config buildkitd.toml
# CPU
docker buildx build -f Dockerfile . -t zhanggaoxing/xmrig-mo:6.21.3 --progress=plain --platform linux/amd64,linux/arm64 --push
docker run -itd --restart=always --privileged=true -v $PWD:/xmrig/configs zhanggaoxing/xmrig-mo:6.21.3
# CUDA
docker build -f Dockerfile_CUDA . -t zhanggaoxing/xmrig-mo:6.21.3-cuda
docker run -itd --restart=always --privileged=true --gpus all -v $PWD:/xmrig/configs zhanggaoxing/xmrig-mo:6.21.3-cuda
```
