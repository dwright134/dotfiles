function transfer
    curl --upload-file $argv[1] https://$TRANSFER_HOST/$argv[1]
end
