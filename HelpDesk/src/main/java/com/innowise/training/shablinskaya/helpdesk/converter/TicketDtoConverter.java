package com.innowise.training.shablinskaya.helpdesk.converter;

import com.innowise.training.shablinskaya.helpdesk.dto.TicketDto;
import com.innowise.training.shablinskaya.helpdesk.entity.Ticket;
import com.innowise.training.shablinskaya.helpdesk.enums.State;
import com.innowise.training.shablinskaya.helpdesk.enums.Urgency;
import com.innowise.training.shablinskaya.helpdesk.service.CategoryService;
import com.innowise.training.shablinskaya.helpdesk.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;
import java.time.Instant;

@Component
public class TicketDtoConverter {
    private final UserService userService;
    private final CategoryService categoryService;

    @Autowired
    public TicketDtoConverter(UserService userService, CategoryService categoryService) {
        this.userService = userService;
        this.categoryService = categoryService;
    }

    public TicketDto toDto(Ticket ticket) {
        TicketDto dto = new TicketDto();

        dto.setId(ticket.getId());
        dto.setName(ticket.getName());
        dto.setDescription(ticket.getDescription());
        dto.setCreationDate(ticket.getCreateDate());
        dto.setResolutionDate(ticket.getResolutionDate());
        dto.setOwner(ticket.getOwner().getEmail());
        dto.setAssignee(ticket.getAssignee() == null ? null : ticket.getAssignee().getEmail());
        dto.setApprove(ticket.getApprove() == null ? null : ticket.getApprove().getEmail());
        dto.setState(ticket.getState().name());
        dto.setCategory(ticket.getCategory().getCategoryName());
        dto.setUrgency(ticket.getUrgency().name());

        return dto;
    }

    public Ticket toEntity(TicketDto dto) {
        Ticket ticket = new Ticket();

        ticket.setName(dto.getName());
        ticket.setDescription(dto.getDescription());
        ticket.setCreateDate(Timestamp.from(Instant.now()));
        ticket.setResolutionDate(dto.getResolutionDate());
        ticket.setOwner(userService.getCurrentUser());
        ticket.setAssignee(null);
        ticket.setApprove(null);
        ticket.setState(State.valueOf(dto.getState()));
        ticket.setCategory(categoryService.findByName(dto.getCategory()));
        ticket.setUrgency(Urgency.valueOf(dto.getUrgency().toUpperCase()));

        return ticket;

    }

    public Ticket toUpdEntity(TicketDto dto) {
        Ticket ticket = new Ticket();

        ticket.setId(dto.getId());
        ticket.setName(dto.getName());
        ticket.setDescription(dto.getDescription());
        ticket.setCreateDate(dto.getCreationDate());
        ticket.setResolutionDate(dto.getResolutionDate());
        ticket.setOwner(userService.findByEmail(dto.getOwner()));
        ticket.setAssignee(dto.getAssignee() == null ? null : userService.findByEmail(dto.getAssignee()));
        ticket.setApprove(dto.getApprove() == null ? null : userService.findByEmail(dto.getApprove()));
        ticket.setState(State.valueOf(dto.getState()));
        ticket.setCategory(categoryService.findByName(dto.getCategory()));
        ticket.setUrgency(Urgency.valueOf(dto.getUrgency().toUpperCase()));

        return ticket;

    }
}
