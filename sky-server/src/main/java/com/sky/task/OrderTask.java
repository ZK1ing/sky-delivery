package com.sky.task;

import com.sky.entity.Orders;
import com.sky.mapper.OrderMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Component
@Slf4j
public class OrderTask {

    @Autowired
    private OrderMapper orderMapper;

    /**
     * 处理支付超时的订单
     */
    @Scheduled(cron = "0 * * * * ?")
    public void processTimeoutOrder() {
        log.info("处理支付超时的订单: {}", new Date());
        // 查询15分钟前的订单
        LocalDateTime time = LocalDateTime.now().minusMinutes(15);
        // 查询状态为待支付的订单
        List<Orders> orders = orderMapper.getByStatusAndOrdertimeLT(Orders.PENDING_PAYMENT, time);

        if (!orders.isEmpty()) { // 添加条件判断，当没有订单需要处理时，直接返回
            for (Orders order : orders) {
                cancelOrder(order);
            }
        } else {
            log.info("没有支付超时的订单。");
        }
    }

    private void cancelOrder(Orders order) {
        order.setStatus(Orders.CANCELLED);
        order.setCancelReason("支付超时，自动取消");
        order.setCancelTime(LocalDateTime.now());
        orderMapper.update(order);
        log.info("订单ID为 {} 的订单已被取消。", order.getId());
    }
    /**
     * 处理派送中状态的订单
     */
    @Scheduled(cron = "0 0 1 * * ?")
    public void processDeliveryOrder() {
        log.info("处理派送中状态的订单:{}",new Date());
        LocalDateTime time = LocalDateTime.now().plusMinutes(-60);
        List<Orders> ordersList = orderMapper.getByStatusAndOrdertimeLT(Orders.DELIVERY_IN_PROGRESS, time);
        if (ordersList != null && ordersList.size() > 0) {
            ordersList.forEach(order -> {
                order.setStatus(Orders.COMPLETED);
                orderMapper.update(order);
            });
        }
    }
}
