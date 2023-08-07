package com.sky.service;

import com.sky.dto.OrdersSubmitDTO;
import com.sky.result.PageResult;
import com.sky.vo.OrderSubmitVO;

public interface OrderService {
    /**
     * 用户下单
     */
    OrderSubmitVO sumbitOrder(OrdersSubmitDTO ordersSubmitDTO);

    PageResult pageQueryUser(int page, int pageSize, Integer status);
}
