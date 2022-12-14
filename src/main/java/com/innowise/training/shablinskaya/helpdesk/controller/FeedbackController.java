package com.innowise.training.shablinskaya.helpdesk.controller;

import com.innowise.training.shablinskaya.helpdesk.dto.FeedbackDto;
import com.innowise.training.shablinskaya.helpdesk.entity.Feedback;
import com.innowise.training.shablinskaya.helpdesk.exception.TicketStateException;
import com.innowise.training.shablinskaya.helpdesk.service.FeedbackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(value = "/feedback", produces = MediaType.APPLICATION_JSON_VALUE)
public class FeedbackController {
    private final FeedbackService feedbackService;


    @Autowired
    public FeedbackController(FeedbackService feedbackService) {
        this.feedbackService = feedbackService;
    }

    @PreAuthorize("@userServiceImpl.hasRole('EMPLOYEE', 'MANAGER')")
    @PostMapping("/create/{id}")
    public ResponseEntity<Feedback> createFeedback(@PathVariable(name = "id") Long id,
                                                   @RequestBody FeedbackDto dto) throws TicketStateException {
        return ResponseEntity.ok(feedbackService.saveFeedback(dto, id));
    }

    @GetMapping("/info/{ticketId}")
    public ResponseEntity<FeedbackDto> getTicketFeedback(@PathVariable(name = "ticketId") Long ticketId) throws TicketStateException {

        return ResponseEntity.ok(feedbackService.getTicketFeedback(ticketId));

    }
}
