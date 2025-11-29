package com.boot;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import java.time.Duration;

@Configuration
public class CacheConfig {

    @Bean
    public RedisCacheManager cacheManager(RedisConnectionFactory connectionFactory) {
        
        // Redis 캐시 기본 설정 정의
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
            // 키(Key) 직렬화 방식을 String으로 설정
            .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer()))
            // 값(Value) 직렬화 방식을 JSON으로 설정 (객체 저장을 위해 필수)
            .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(new GenericJackson2JsonRedisSerializer()))
            // **핵심: 캐시 만료 시간을 10분으로 설정**
            .entryTtl(Duration.ofMinutes(10)) 
            // null 값은 캐싱하지 않음
            .disableCachingNullValues(); 

        return RedisCacheManager.builder(connectionFactory)
            .cacheDefaults(config) // 모든 캐시에 기본 10분 TTL 적용
            .build();
    }
}