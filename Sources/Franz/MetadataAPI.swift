//
//  MetadataAPI.swift
//  Franz
//
//  Created by Kellan Cummings on 1/14/16.
//  Copyright © 2016 Kellan Cummings. All rights reserved.
//

import Foundation


class TopicMetadataRequest: KafkaRequest {

    convenience init(topic: String) {
        self.init(message: TopicMetadataRequestMessage(values: [topic]))
    }

    convenience init(topics: [String] = []) {
        self.init(message: TopicMetadataRequestMessage(values: topics))
    }
    
    init(message: TopicMetadataRequestMessage) {
        super.init(
            apiKey: ApiKey.metadataRequest,
            value: message
        )
    }

}

class TopicMetadataRequestMessage: KafkaType {

    var values: [String]
    
    init(values: [String]) {
        self.values = values
    }

    required init(data: inout Data) {
        values = [String](data: &data)
    }

    lazy var dataLength: Int = {
        return self.values.dataLength
    }()
    
    lazy var data: Data = {
        return (self.values.data)
    }()
}

class MetadataResponse: KafkaResponse {
    
    private var _metadataBrokers: [Broker]
    private var _topicMetadata: [KafkaTopic]
    
    var brokers: [Int32: Broker] {
        var values = [Int32: Broker]()
        for value in _metadataBrokers {
            values[value.nodeId] = value
        }
        return values
    }
    
    var topics: [String: KafkaTopic] {
        var values = [String: KafkaTopic]()
        for value in _topicMetadata {
            if let name = value.name {
                values[name] = value
            }
        }
        return values
    }
    
    required init(data: inout Data) {
        _metadataBrokers = [Broker](data: &data)
        _topicMetadata = [KafkaTopic](data: &data)
    }
	
	var data: Data {
		return _metadataBrokers.data + _topicMetadata.data
	}
	
	var dataLength: Int {
		return _metadataBrokers.dataLength + _topicMetadata.dataLength
	}
}
